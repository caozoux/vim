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

"只能处理不相同的匹配符合，"和', issame 应为1
function! AutoBlacker(pchar, issame)
	if (&paste)
		return
	endif
	let partern_s = ['{', "\"", "'", "[", "("]
	let partern_e = ['}', "\"", "'", "]", ")"]
	let save_cursor = getpos('.')
	let new_position= save_cursor[1] + 1
	let cur_line = getline(save_cursor[1])
	let index = index(partern_s, a:pchar)
	let partern_s_c = partern_s[index]
	let partern_e_c = partern_e[index]
	if index >= 0
		let find_cnt_e = 0
		let find_cnt_c = 0
		for i in  range(strlen(cur_line))
			if cur_line[i] == partern_s_c
				let find_cnt_c += 1	
			elseif cur_line[i] == partern_e_c
				let find_cnt_e += 1	
			endif	
		endfor
		"如果不是匹配的，只输入parter_s_c就可以了
		if a:issame
			if find_cnt_c%2 == 1
				execute "normal! a".partern_s_c
				return
			endif	
		else
			if find_cnt_e != find_cnt_c
				execute "normal! a".partern_s_c
				return
			endif
		endif
	endif
	execute "normal! a".partern_s_c.partern_e_c
endfunction

"通过空格字符，快速生成linePatarn 的结构
"参数$@, $1 ,$2,$....
function! MeFastGoFormatLineV2(printStr, dataStr, format)
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
		"call add(wordextend, ":%08x ")
		call add(wordextend, a:format)
	endfor
	call add(wordextend, "\\n\"")
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

"通过空格字符，快速生成linePatarn 的结构
"参数$@, $1 ,$2,$....
function! MeFastFormatLineV2(printStr, dataStr, format)
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
		"call add(wordextend, ":%08x ")
		call add(wordextend, a:format)
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

"通过空格字符，快速生成linePatarn 的结构
"参数$@, $1 ,$2,$....
function! MePythonPrint(printStr, dataStr, format)
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
	""for item in wordlist
	""	call add(wordextend, item)
	""endfor
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

function! PrintkPast()
	let save_cursor = getpos('.')
	let linetxt = getline(line('.'))
	let showcontext=[]
	call add(showcontext, linetxt)
	call add(showcontext, "printk(\"zz %s %d \\n\", __func__, __LINE__);")
	call setline(line('.'), join(showcontext, ''))
endfunction

"得到路径中的文件名
function! GetFilenameWithoutPath(filename)
	let filebasename=""
python3 << EOF
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
