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
	let endnumber=search("^@@ -")
	let delline_cnt=endnumber-startnumber
	call cursor(startnumber, 0)
	execute "normal ". delline_cnt. "dd"
	""execute "normal 13dd"
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

function! GetPatchConflict()
	let gitapplyerr=[]
	let patchname=""
	let patchitem_head=""
	let patchitem_start=[]
	let patchitem_end=[]
	call ClearBufAll("patchcmdbuf")
python << EOF
import os
import vim
import re
patchbuffer = vim.current.buffer
gitapplybuf=os.popen("git -C /fslink/kernel-4.1.x apply "+patchbuffer.name+" 2>&1"+" | grep \"error: patch failed:\" ").readlines();
patchcmdbuf=""
#insert the git apply error to patchcmdbuf
for b in vim.buffers:
	if b.name.find("patchcmdbuf") >= 0:
		patchcmdbuf = b
		patchcmdbuf.append("".join(gitapplybuf))
for line in  gitapplybuf:
	res=re.search(":[0-9]*\n", line)
	if res:
		conflictnumber= res.group(0)[1:-1]
		vim.command("call insert(gitapplyerr, \"@@ -"+str(conflictnumber)+"\")")
vim.command("let patchname = \""+patchbuffer.name+"\"")
EOF
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
