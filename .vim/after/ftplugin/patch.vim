"if exists("b:did_ftplugin")
"  finish
"endif
"let b:did_ftplugin = 1  " Don't load another plugin for this buffer

function! ClearBufAll(buffername)
	let oldwinid = win_getid()
	let delwinid = bufwinid(a:buffername)
	if delwinid != -1
		call win_gotoid(delwinid)
		execute "normal gg dG"
		call win_gotoid(oldwinid)
	endif
endfunction

function! JumToSerach(search_var)
	"跳到search_var的位置
	""let line = substitute(a:search_var, "*", "\\\\*", 0)
	""let line = substitute(line, ". ", "\\\\.", 0)
	let line = substitute(a:search_var, "*", "\\\\*", 'g')
	""let line = substitute(line, ". ", "\.", 0)
	let number=search(line)
	return number
endfunction


function! JumToPatchItemHead()
	"跳到patchitem的开头
	let line = getline(".")
	if line[0] != "@"
		let number=search("^@@.*", 'b')
	endif
endfunction

function! DelPatchItem()
	let line = getline(line('.'))
	if line[0] != "@"
		call JumToPatchItemHead()
	endif
	let startnumber = line('.')

	let endnumber=search("^@@ -", 'nW')
	if 0 == endnumber
		"patchitem is last
		let endnumber=search("^-- ", 'nW')
	else
		"确认是否是patchitem所在的目标文件结尾
		call cursor(startnumber, 0)
		let oldnumber = endnumber
		let endnumber=search("^diff", 'nW')
		if endnumber != 0
			if endnumber > oldnumber
				let endnumber = oldnumber
			endif
		else
			let endnumber = oldnumber
		endif
	endif
	let delline_cnt=endnumber-startnumber
	call cursor(startnumber, 0)
	execute "normal ". delline_cnt. "dd"

	"确认目标文件的patchitem已经没有了，如果是，清除它
	let line = getline(line('.'))
	let line1 = getline(startnumber-1)
	let postion=match(line1, "^+++ b")
	if postion == 0
		let postion=match(line, "^diff ")
		if postion == 0
			call cursor(startnumber-4, 0)
			execute "normal 4dd"
		endif
	endif

endfunction

function! GetPatchItemFile()
	"跳到patchitem的开头
	let line = getline(".")
	"if line[0] != '+' && line[1] != '+' & line[2] != '+'
	let strv = match("^+++ b", line)
	"if line[2] != '+'
	if strv == -1
		let number=search("^\+\+\+.*", 'b')
		call cursor(number-1, 0)
	endif
endfunction

function! JumPathItemStartInTarget(start)
	let line0 = substitute(line0, "^ ", "", 0)
	let line0 = substitute(line1, "*", "\*", 0)
	let line0 = substitute(line2, ". ", "\.", 0)
	let number=search(line0)
	if number > 0
		call cursor(number, 0)
		return 1;
	endif
	return 0;

endfunction

function! OpenMergePatch(patchdir)

	let patchname=""
python << EOF
import os
import vim

number=open("./.git/rebase-apply/next").read()
number=number[:-1]
num=4-len(number)
for i in range(num):
	number= "0"+number
dirname=vim.bindeval("a:patchdir")
filename=dirname+"/"+number+"-*"
res=os.popen("ls "+filename).readlines()
filename=res[0][:-1]
vim.command("let patchname = \""+filename+"\"")
EOF
	"let patchname="cach/0003-\\*"
	echo ":edit " patchname
	execute ":edit " patchname

endfunction

function! GetPatchConflict()
	let gitapplyerr=[]
	let patchname=""
	let patchitem_head=""
	let patchitem_start=[]
	let patchitem_end=[]

	let backwinid = win_getid()
	echo backwinid
	execute ":only"
	"清除patchcmdbuf的内容
	let patchcmdbuf_winid = bufwinid("patchcmdbuf")
	if patchcmdbuf_winid == -1
		execute ":7sp patchcmdbuf"
		setlocal buftype=nofile
		call win_gotoid(backwinid)
	endif
	call ClearBufAll("patchcmdbuf")
python << EOF
import os
import vim
import re
gitdir=os.popen("pwd").read()
patchbuffer = vim.current.buffer
gitapplybuf=os.popen("git -C "+gitdir[:-1]+" apply "+patchbuffer.name+" 2>&1"+" | grep \"error: patch failed:\" ").readlines();
gitapplynofile=os.popen("git -C "+gitdir[:-1]+" apply "+patchbuffer.name+" 2>&1"+" | grep \"No such file\" ").readlines();
patchcmdbuf=""
#insert the git apply error to patchcmdbuf
for b in vim.buffers:
	if b.name.find("patchcmdbuf") >= 0:
		patchcmdbuf = b
		#patchcmdbuf.append("".join(gitapplybuf))
		patchcmdbuf.append(gitapplybuf)

if len(gitapplybuf) == 0:
	#it is pass
	if len(gitapplynofile) == 0:
		patchcmdbuf.append("patch has been passed")
	else:
		patchcmdbuf.append("".join(gitapplynofile))
else:
	for line in  gitapplybuf:
		res=re.search(":[0-9]*\n", line)
		if res:
			conflictnumber= res.group(0)[1:-1]
			vim.command("call insert(gitapplyerr, \"@@ -"+str(conflictnumber)+"\")")
	vim.command("let patchname = \""+patchbuffer.name+"\"")
EOF
	if empty(gitapplyerr)
		return
	endif

	let patchwind_id = win_getid()
	"跳转到git applay 出错的地方
	let err_line = JumToSerach(gitapplyerr[0])
	let var=line('.')
	let line = getline('.')
	let patchitem_head = substitute(line, "^@@.*@@ ", "", 0)

	"得到patchitem 首3行
	let var = var + 2
	for i in range(3)
		call add(patchitem_start, getline(var+i))
	endfor

	"跳转到patchitem目标文件位置
	call GetPatchItemFile()
	let line = getline('.')
	"得到了patchitem 目标文件"
	let patchmodify_file = substitute(line, "--- a/", "", 0)

	let basename = GetFilenameWithoutPath(patchmodify_file)
	"确认当前文件是打开的
	if bufwinid(basename) == -1
		execute ":vsplit " patchmodify_file
	else
		"没有vspllit,这里跳转到目标文件
		call win_gotoid(bufwinid(basename))
	endif
	let srcfilewind_id = win_getid()
	"跳转到patchitem在目标文件的位置
	call JumToSerach(patchitem_head)
	normal! zz

	"跳回patch文件出错的patchitem
	call win_gotoid(patchwind_id)
	call cursor(err_line, 0)
	normal! zz
endfunction

function! JumToPatchItemEnd()
	let cur_option = line('.')
	let line = getline(".")
	let var1 = search("^@@.*", 'W')
	call cursor(cur_option, 0)

	"如果是做后一个item, 末尾要么是diff 或者 --
	let var2 = search("^diff", 'W')
	if var2 < var1
		"是patch 一个file的最后一行
		normal! k 
		return
	endif
	"cursor(cur_option, 0)

	"call search("^-- $", 'W')
	"let var3 = line('.')
		
	normal! k 
endfunction


function! DoMerge(targfile)
	let basename = GetFilenameWithoutPath(a:targfile)
	let patchwind_id = win_getid()
	let patchitem_end=[]
	let patchitem_buf=[]
	let search_end=""

	call JumToPatchItemHead()
	let s_var=line('.')
	let s_var = s_var+3

	call JumToPatchItemEnd()
	let e_var=line('.')

	for i in  range(e_var-s_var)
		let line = getline(s_var+i)
		call add(patchitem_buf, line)
	endfor

	for i in range(3)
		let line = getline(e_var-2+i)
      	let line= substitute(line, '^ ', '', 'g')
		let line= substitute(line, "\t", "\\t", 'g')
		let line= substitute(line, "*", "\\\\*", 'g')
		call add(patchitem_end, line)
		call add(patchitem_end, "\\_.")
	endfor

	let search_end = join(patchitem_end, '')
	"let search_end= substitute(search_end, "\t", "\\\\t", 'g')
	call win_gotoid(bufwinid(basename))
	let targfile_id = win_getid()
	if search(search_end) <= 0
		echo search_end
		return
	endif

	let handle_lines=[]
	let t_number_end = line('.')
	let t_number_end = t_number_end - 1
	let index=0
	let patchitem_size  = len(patchitem_buf)
	"call append(t_number_end, patchitem_buf)
	for i in  range(1, patchitem_size)
		let index= patchitem_size-i
		let line = patchitem_buf[index]
		if line[0] == "+"
			call append(t_number_end, line)
			call add(handle_lines, patchitem_buf[index])
			"let t_number_end -= 1
		elseif line[0] == "-"
			let t = 0
		elseif line[0] == " "
			let t = 0
		endif
	endfor

	call win_gotoid(patchwind_id)
	call cursor(e_var-3, 0)

	let cur_option = line('.')
	let patchitem_size  = len(handle_lines)
	for i in range(patchitem_size)
		normal dd
		normal k
	endfor

endfunction

function! MergePatchitem()
	let patchitem_start=[]
	let patchitem_end=[]
	let patchwind_id = win_getid()
	call JumToPatchItemHead()
	let var=line('.')
	let curretn_position=var
	let line = getline('.')
	let patchitem_head = substitute(line, "^@@.*@@ ", "", 0)

	let var = var + 2
	for i in range(3)
		call add(patchitem_start, getline(var+i))
	endfor

	"跳转到patchitem目标文件位置
	call GetPatchItemFile()
	let line = getline('.')
	"得到了patchitem 目标文件"
	let patchmodify_file = substitute(line, "--- a/", "", 0)

	let basename = GetFilenameWithoutPath(patchmodify_file)
	"确认当前文件是打开的
	if bufwinid(basename) == -1
		execute ":vsplit " patchmodify_file
	else
		"没有vspllit,这里跳转到目标文件
		call win_gotoid(bufwinid(basename))
	endif
	let srcfilewind_id = win_getid()
	"跳转到patchitem在目标文件的位置
	call JumToSerach(patchitem_head)
	normal! zz

	"跳回patch文件出错的patchitem
	call win_gotoid(patchwind_id)
	call cursor(curretn_position, 0)
	normal! zz

	"得到patch item 末尾3行
	call JumToPatchItemEnd()
	let var=line('.')
	for i in range(3)
		call add(patchitem_end, getline(var-3+i))
	endfor
	call cursor(curretn_position, 0)
	call DoMerge(basename)
endfunction

let patchcmdbuf_winid = bufwinid("patchcmdbuf")
if patchcmdbuf_winid == -1
	execute ":7sp patchcmdbuf"
	execute ":close"
endif

map <c-x>d <ESC>:call DelPatchItem()<CR>
map <c-x>t <ESC>:call GetPatchConflict()<CR>
map <c-x>f <ESC>:call OpenMergePatch("cach")<CR>
map <c-x>c <ESC>:source ~/.vim/after/ftplugin/patch.vim<CR> <ESC>:call MergePatchitem()<CR>
vnoremap c :s/^[+-\s]//<CR>:w<CR>
