let s:count=0
let s:r_start=0 " check the while back to the start of buffer
let s:mbuf_list=[] " check the while back to the start of buffer
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
	execute "normal oprintk(\"zz \%s \\n\", __func__);\<ESC>"
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

let s:custom_list = ["for (i=0; i<; i++) {","spangle","frizzle"]
func! CustomComplete()
	echom 'move to start of last word'
	normal b
	echom 'select word under cursor'
	let b:word = expand('<cword>')
	echom '->'.b:word.'<-'
	echom 'save position'
	let b:position = col('.')
	echom '->'.b:position.'<-'
	normal e
	normal l
	echom 'move to end of word'

	let b:matches = []


	echom 'begin checking for completion'
	for item in s:custom_list
	echom 'checking '
	echom '->'.item.'<-'      
			if(match(item,'^'.b:word)==0)
			echom 'adding to matches'
			echom '->'.item.'<-'      
			call add(b:matches,item)
			endif
	endfor
	call complete(b:position, b:matches)

	return ''
endfunc
function! MjumpBuff()
	let cur_line = getline(line("."))
	execute ":u"
	execute ":buffer " cur_line
endfunc

func! MbufComplete()
	call MscanBuf()
	let b:position = col('.')
	call complete(b:position,s:mbuf_list)
	return ''
endfunc

func! MscanBuf()
	let i = 0
	while i < argc()
		"call add(b:mbuf_list, argv(i))
		if filereadable(argv(i))
			call add(s:mbuf_list, argv(i))
		let i=i+1
	endwhile
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
        let pat = ') {'
        let save_cursor = getpos('.')
		let new_position= save_cursor[1] + 1
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'b', save_cursor[1]))
           normal! o}
           normal! ko    
			":call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
        	:call cursor(new_position, save_cursor[2], save_cursor[3])
		else 
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
        let pat = '["]'
        let save_cursor = getpos('.')
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'c', save_cursor[1]))
        	:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
           normal! a"
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

inoremap { {<ESC>:call AutoBlacker()<CR>
inoremap [ [<ESC>:call AutoChar1()<CR>i
inoremap " "<ESC>:call AutoChar2()<CR>i
inoremap ( (<ESC>:call AutoChar3()<CR>i
inoremap ;  <ESC>:call  AutoChar4()<CR>i

func! Tag_kernel_set()
	set tags+=/home/zoucao/github/shell/ctag/linux_base-tags
endfunc

func! MeDbg()
	echo g:paste
endfunc


