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

function! Me_pr_func1(type)
	execute "normal koprintk(\"zz \%s +\\n\", __func__);\<ESC>j\<ESC>"
	execute "normal oprintk(\"zz \%s -\\n\", __func__);\<ESC>k\<ESC>"
endfunction 

function! Me_auto_for(type)
	execute "normal ofor (i=0; i<; i++)\<ESC>o{\<ESC>o\<ESC>o}\<ESC>"
endfunction 

function! Me_auto_if(type)
	execute "normal oif ( ) {\<ESC>o\<ESC>o}\<ESC>"
endfunction 

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

function! Msleep()
	let cur_line = getline(line("."))
	let old_len=strlen(cur_line)
	let new_line=strlen(getline(line(".")))
	while new_line == old_len
		sleep 100m
		let old_len=strlen(cur_line)
		let new_line=strlen(getline(line(".")))
	endwhile
	"call complete(b:position,s:mbuf_list)
	return ''
endfunc

func! MbufComplete()
	"let b:position = col('.')
	call MscanBuf()
	"sleep 100m
	let b:position = col('.')
	call complete(b:position,s:mbuf_list)
	return ''
endfunc

func! MscanBuf()
	let i = 0
	while i < argc()
		"call add(b:mbuf_list, argv(i))
		call add(s:mbuf_list, argv(i))
		echo argv(i)
		let i=i+1
	endwhile
endfunc

func! MeDbg()
	call MjumpBuff()
endfunc
