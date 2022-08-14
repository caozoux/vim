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
		else
			let postion=match(line, "^-- ")
			if postion == 0
				call cursor(startnumber-4, 0)
				execute "normal 4dd"
			endif
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
python3 << EOF
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
python3 << EOF
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
	let var1 = search("^@@.*", 'W')

	"是patch 做后一个item
	if var1 == 0
		call search("^-- $", 'W')
		call cursor(line('.')-1, 0)
		return	
	endif

	call cursor(cur_option, 0)
	let var2 = search("^diff ", 'W')
	if var2 == 0
		call cursor(var1-1, 0)
		return
	endif

	if var1 > var2
		call cursor(var2-1, 0)
		return
	endif
	call cursor(var1-1, 0)

	return
	"是patch file中做后一个item
	let line = getline(var1-1)
	if match(line, "^+++ b") == 0
		call cursor(var1-6, 0)
		return
	endif
	call cursor(var1-1, 0)

endfunction


function! DoMerge(targfile)
	let basename = GetFilenameWithoutPath(a:targfile)
	let patchwind_id = win_getid()
	let patchitem_end=[]
	let patchitem_srt=[]
	let patchitem_buf=[]
	let search_end=""
	let search_srt=""
	let t_number_end=0
	let t_number_srt=0

	call JumToPatchItemHead()
	let s_var=line('.')
	let s_var = s_var+3

	call JumToPatchItemEnd()
	let e_var=line('.')

	for i in  range(e_var-s_var-3)
		let line = getline(s_var+i+1)
		call add(patchitem_buf, line)
	endfor


	"得到item前3行
	for i in range(3)
		let line = getline(s_var-2+i)
      	let line= substitute(line, '^ ', '', 'g')
		let line= substitute(line, "\\", "\\\\\\\\", 'g')
		let line= substitute(line, "\t", "\\\\t", 'g')
		let line= substitute(line, "*", "\\\\*", 'g')
		let line= substitute(line, "\[", "\\\\[", 'g')
		let line= substitute(line, "\]", "\\\\]", 'g')
		"最后一行不用\_., \_.表示任何字符包括在新行,去掉，第一行加入^
		if i == 0
			let line= substitute(line, "^", "^", 'g')
			call add(patchitem_srt, line)
			call add(patchitem_srt, "\\_.")
		else
			let line= substitute(line, "$", "\\\\n", '')
			call add(patchitem_srt, line)
		endif
	endfor
	let search_srt = join(patchitem_srt, '')
	""echo search_srt
	""return 

	"得到item后3行
	for i in range(3)
		let line = getline(e_var-2+i)
      	let line= substitute(line, '^ ', '', 'g')
		let line= substitute(line, "\\", "\\\\\\\\", 'g')
		let line= substitute(line, "\t", "\\\\t", 'g')
		let line= substitute(line, "*", "\\\\*", 'g')
		let line= substitute(line, "\[", "\\\\[", 'g')
		let line= substitute(line, "\]", "\\\\]", 'g')
		"最后一行不用\_., \_.表示任何字符包括在新行,去掉，第一行加入^
		if i == 0
			let line= substitute(line, "^", "^", 'g')
			call add(patchitem_end, line)
			call add(patchitem_end, "\\_.")
		else
			if len(line) == 0
				let line= substitute(line, "$", "\\\\n", '')
			else
				let line= substitute(line, "$", "\\\\n", '')
				call add(patchitem_end, line)
			endif 
		endif
	endfor

	let search_end = join(patchitem_end, '')
	""echo search_end
	"return 

	"跳转到patch item 目标文件， 匹配item首3行或者尾3行
	call win_gotoid(bufwinid(basename))
	let targfile_id = win_getid()

	if search(search_srt) <= 0
		"echo search_srt
		if search(search_end) <= 0
			echo search_end
			return
		else
			let t_number_end = line('.')
			let t_number_end = t_number_end - 1
		endif
	else
		call win_gotoid(patchwind_id)
		call JumToPatchItemHead()
		call win_gotoid(targfile_id)
		let t_number_srt = line('.')
		let t_number_srt = t_number_srt + 2
		let t_number_end = 0
		call cursor(t_number_srt, 0)
	endif

	let handle_lines=[]
	let index=0
	let patchitem_size  = len(patchitem_buf)
	let e_var -= 3

	"从尾部往上merge
	if t_number_end != 0
		"call append(t_number_end, patchitem_buf)
		for i in  range(patchitem_size)
			let index= patchitem_size-i-1
			let line = patchitem_buf[index]
			if line[0] == "+"
				call append(t_number_end, line)
				"将处理的行在行首加字符^
				call win_gotoid(patchwind_id)
				call cursor(e_var, 0)
				let patch_line=getline('.')
				let patch_line= substitute(patch_line, "^", "`", 0)
				normal dd
				let e_var = e_var - 1
				call append(e_var, patch_line)
				call win_gotoid(targfile_id)
			 	sleep 1m
			elseif line[0] == "-"
				let cmp_str_src = getline(t_number_end)
				let cmp_str_dst = substitute(line, "^-", "", 0)
				if cmp_str_src == cmp_str_dst
					"将处理的行在行首加字符^
					normal dd
					call win_gotoid(patchwind_id)
					call cursor(e_var, 0)
					let patch_line= substitute(line, "^", "`", 0)
					normal dd
					call append(e_var-1, patch_line)
					let e_var = e_var - 1
					call win_gotoid(targfile_id)
					sleep 1m
				else
					return
				endif
				return
			elseif line[0] == " "
				return
			endif
		endfor
	endif

	"从首部往下merge
	if t_number_srt != 0
		let t_number_srt = t_number_srt + 1
		normal j
		""for i in  range(1)
		for i in  range(patchitem_size)
			let line = patchitem_buf[i]
			if line[0] == "+"
				call append(t_number_srt-1, line)
				let t_number_srt = t_number_srt + 1
				call cursor(t_number_srt, 0)
				"跳转套patch，删除已经处理的"+"行
				call win_gotoid(patchwind_id)
				call cursor(s_var+1, 0)
				let patch_line=getline('.')
				let patch_line= substitute(patch_line, "^", "`", 0)
				normal dd
				call append(s_var, patch_line)
				let s_var = s_var + 1
				call win_gotoid(targfile_id)
			 	sleep 1m
			elseif line[0] == "-"
				let cmp_str_src = getline(t_number_srt)
				let cmp_str_dst = substitute(line, "^-", "", 0)
				if cmp_str_src == cmp_str_dst
					normal dd
					call win_gotoid(patchwind_id)
					call cursor(s_var+1, 0)
					let patch_line= substitute(line, "^", "`", 0)
					normal dd
					call append(s_var, patch_line)
					let s_var = s_var + 1
					call win_gotoid(targfile_id)
				else
					return
				endif
			 	sleep 1m
			elseif line[0] == " "
				let cmp_str_src = getline(t_number_srt)
				let cmp_str_dst = substitute(line, "^ ", "", 0)
				if cmp_str_src == cmp_str_dst
					let t_number_srt = t_number_srt + 1
					"让s_var 向上+1
					let s_var = s_var + 1
					normal j
				else
					return
				endif
			endif
		endfor
		""call append(t_number_srt, patchitem_buf)
	endif

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
