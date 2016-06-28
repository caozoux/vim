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

function! Me_pr_func2(type)
	execute "set paste"
	execute "normal oprintk(\"zz \%s \\n\", __func__);\<ESC>"
	execute "set nopaste"
endfunction 

function! Me_Tag(TagType)
	if a:TagType == "kernel"
		set tags&
		set tags+=/home/wrsadmin/bin/tag/common/out/linux_base-tags
		set tags+=/home/wrsadmin/bin/tag/common/out/driver_common-tags
		set tags+=/home/wrsadmin/bin/tag/common/linux_base_plat
		cs reset
   		cs add /home/wrsadmin/bin/tag/cscope.out
	elseif a:TagType == "user"
	endif
	for tagname in a:tags
		echo tagname
	endfor
endfunction

"custom complete mem popup

function! MjumpBuff()
	let cur_line = getline(line("."))
	execute ":u"
	execute ":buffer " cur_line
endfunc

func! MVimFuncComplete()
	let stylesheet = readfile("/home/zoucao/.vim/after/ftplugin/vim_dictionary.txt")
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

function! AutoChar1()
	if (&paste)
		return
	endif
	let pat = '[/[]'
	let save_cursor = getpos('.')
	let result = matchstr(getline(save_cursor[1]), pat)
	if (search(pat, 'c', save_cursor[1]))
		:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
	   normal! a]
   endif
endfunction

function! AutoChar2()
	if (&paste)
		return
	endif
	let pat = '"'
	let save_cursor = getpos('.')
	let result = matchstr(getline(save_cursor[1]), pat)
	if (search(pat, 'c', save_cursor[1]))
		let linetxt = getline(save_cursor[1])
		let cnt=0
		let ret=-1
		while 1
			let ret = match(linetxt,"\"",ret+1)
			if ret == -1
				break
			endif
			let cnt += 1
		endwhile
		if cnt%2 != 0
			normal! a"
		endif
		:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
   	endif
endfunction

"auto patern for '('
function! AutoChar3()
	if (&paste)
		return
	endif

	let pat = '('
	let save_cursor = getpos('.')
	let result = matchstr(getline(save_cursor[1]), pat)
	if (search(pat, 'c', save_cursor[1]))
		normal! a)
		:call cursor(save_cursor[1], save_cursor[2]+1, save_cursor[3])
	endif
endfunction

"auto patern for '('
function! AutoChar4()
	if (&paste)
		return
	endif

	let pat = 'for'
	let save_cursor = getpos('.')
	let result = matchstr(getline(save_cursor[1]), pat)

	if (search(pat, 'c', save_cursor[1]))
		return
	else
		normal! $a;
		normal! o
	endif
endfunction

"inoremap { {<ESC>:call AutoBlacker()<CR>i
"inoremap [ [<ESC>:call AutoChar1()<CR>i
inoremap " "<ESC>:call AutoChar2()<CR>i
"inoremap ( (<ESC>:call AutoChar3()<CR>i
"inoremap ;  <ESC>:call  AutoChar4()<CR>i

func! Tag_kernel_set()
	set tags+=/home/zoucao/github/shell/ctag/linux_base-tags
endfunc

func! MeDbg()
	echo g:paste
endfunc


