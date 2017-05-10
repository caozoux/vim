let s:count=0
let s:r_start=0 " check the while back to the start of buffer
function! Me_zf_funcs(type)
	" 折叠c文件所有函数和数据
	let s:count = 0

	call search("{")
	"execute "normal }}\<ESC>"
	let b:r_start = line('.') " first search {, recoard the line for checking the end of while loop
	echo b:r_start
	execute "normal zf% j\<ESC>"

	while 1
		let b:r_cur = line('.') "check if zd is the end of file, if it is, break the loop
		execute "normal j\<ESC>"
		if line('.') == b:r_cur
			break
		endif

		call search("{")
		if line('.') <= b:r_start
			"end loop
			break
		endif
		execute "normal zf% j\<ESC>"
		let s:count += 1

	endwhile
	"echo s:count
endfunction " 

func! MVimFuncComplete()
	let stylesheet = readfile("/home/wrsadmin/.vim/after/ftplugin/vim_dictionary.txt")
	normal b
	let b:matches = []
	let b:dbg_a= []
	let b:position = col('.')
	let b:word = expand('<cword>') "get current word"
	for item in stylesheet
		if(match(item,'^'.b:word)==0)
			call add(b:matches,item)
		endif
	endfor
	echom b:word
	call complete(b:position,b:matches)
	return ''
endfunc

"fast open the patch modify file
"like :+++ b/drivrs/base/core.c
func! Patch_vsplit_open()
	let b:r_cur = getline(".")
	let b:postion = match(b:r_cur, "+++ b/")
	if (b:postion == 0)
		let b:f_name = strpart(b:r_cur, 6)
		execute ":vsplit " b:f_name
	endif
endfunc

function! AutoBlacker()
	if (&paste)
		return
	endif
	let pat = '[^=] {'
	let save_cursor = getpos('.')
	let new_position= save_cursor[1] + 1
	let result = matchstr(getline(save_cursor[1]), pat)
	if (search(pat, 'b', save_cursor[1]))
	   normal! o}
	   normal! ko    
		":call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
		:call cursor(new_position, save_cursor[2], save_cursor[3])
	else 
	   normal! a}
		:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
	endif
endfunction

"通过空格字符，快速生成linePatarn 的结构
"参数$@, $1 ,$2,$....
function! MeFastFormatLineV2(printStr, dataStr)
	normal! ^
	let save_cursor = getpos('.')
	let linetxt = getline(line('.'))
	let idx =0
	while idx < strlen(linetxt)
		if linetxt[idx] =~ '\w'
            break
		else
			let idx += 1
		endif
	endwhile
	let wordlist = split(strpart(linetxt, idx))
	let showcontext=[]
	let wordextend=[]
	if idx > 0
		call add(showcontext,strpart(linetxt, 0, idx))
	endif
	call add(showcontext, a:printStr)
	for item in wordlist
		call add(wordextend, item)
		call add(wordextend, ":%08x ")
	endfor
	call add(wordextend, "\\n\",__func__")
	for item in wordlist
		"call add(wordextend, " ,(u32)")
		call add(wordextend, a:dataStr)
		call add(wordextend, item)
	endfor
	call add(wordextend, ");")
	call extend(showcontext,wordextend)
	call append(line('.'), join(showcontext, ''))
	execute "d"
endfunction

"得到路径中的文件名
function! GetFilenameWithoutPath(filename)
	let filebasename=""
python << EOF
import os
import vim
filename = vim.bindeval("a:filename")
basename = os.path.basename(filename)
vim.command("let filebasename=\""+basename+"\"")
EOF
	return filebasename
endfunction

func! MeDbg()
	call MeFastFormatPrintk()
endfunc

"处理entry键, 检测{
function! EntryKeyExter()
	let line = getline(".")
	let start = col('.')
	if line[start] == "{"
	   normal! o}
	   normal! ko
	else
	   normal! o
	endif
endfunction
