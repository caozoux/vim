"target txt
let s:objfunclist=[] 
"target extern context
let s:objdictionary={}
let s:objfunc_dictonarydirfile="~/.vim/after/ftplugin/objcomplete/"
"保存扩展字典文件名
let s:objfunc_dictonaryextfile=""
let s:objfunc_dictonaryfile=""
"保存扩展字典文件名
let s:objfunc_dictonaryextfile=""
"set iskeyword+=#
"objfunc的回调函数，类似omnifunc
function! Objomnicomplete(findstart, base)
    if a:findstart == 1
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~# '[a-zA-Z0-9:_\@\-\<\>\#]'
		  let start -= 1
		endwhile
		return start
    else
		let retOmnilist =[]
        let line = getline('.')
        let idx = col('.')
        let cword = ''
		for item in s:objfunclist
			let linesplit = split(item, "\t")
			if (match(linesplit[0],'^'.a:base)==0)
				if len(linesplit) > 1
					echo linesplit[0]
					if has_key(s:objdictionary, linesplit[0])
						call extend(retOmnilist, [{"word":linesplit[0], "kind":linesplit[1], "info":s:objdictionary[linesplit[0]]}])
					else
						call extend(retOmnilist, [{"word":linesplit[0], "kind":linesplit[1], "info":"null"}])
					endif
				else	
					call extend(retOmnilist, [{"word":linesplit[0], "kind":"null", "info":"null"}])
				endif
			endif
		endfor
		return retOmnilist
    endif
endfunction

function! ObjCompleteSetMode(mode)
	let s:objfunclist=[]
	let s:objdictionary={}
	if a:mode == "kernel"
		call ObjDictionUpdate("~/.vim/after/ftplugin/objcomplete/kernel/api_dictionary.txt","~/.vim/after/ftplugin/objcomplete/kernel/api_dictionary_extern.txt")
	elseif a:mode == "qt"
		let s:objfunc_dictonaryfile=s:objfunc_dictonarydirfile."qt/qt_dictionary.txt" 
		let s:objfunc_dictonaryextfile=s:objfunc_dictonarydirfile."qt/qt_dictionary_extern.txt" 
		call ObjDictionUpdate(s:objfunc_dictonaryfile, s:objfunc_dictonaryextfile)
	elseif a:mode == "c_or_cpp"
		let s:objfunc_dictonaryfile=s:objfunc_dictonarydirfile."c_or_cpp/c_or_cpp_dictionary.txt" 
		let s:objfunc_dictonaryextfile=s:objfunc_dictonarydirfile."c_or_cpp/c_or_cpp_dictionary_ex.txt" 
		call ObjDictionUpdate(s:objfunc_dictonaryfile, s:objfunc_dictonaryextfile)
	endif
endfunction

func! ObjDictionUpdate(f_diction, exf_diction)
	let home=system("echo $HOME")
	let home=strpart(home,0, len(home)-1)
	let b:adid_ftplugin = 1

	let s:objfunc_dictonaryfile=a:f_diction
	let s:objfunc_dictonaryextfile=a:exf_diction
python << EOF


import os
import vim
from vimscript import vimobjcomplete
f_diction = vim.bindeval("a:f_diction")
exf_diction = vim.bindeval("a:exf_diction")
home=vim.bindeval("home")
comManger= vimobjcomplete.ObjCompleteManger(home+f_diction[1:], home+exf_diction[1:])
comManger.transferToHead()
objextern_dict=vim.bindeval('s:objdictionary');
for obj in comManger.headObjList:
	vim.command("call insert(s:objfunclist,"+"\""+obj.headline+"\""+")")
	extern_str = comManger.getExtern(obj.head)
	if extern_str:
		objextern_dict.update({obj.head : extern_str})
EOF
endfunc

if exists("&objfunc")
	set objfunc=Objomnicomplete
endif

function! SetObjCompleteMode(mode)
	if a:mde == "qt":
	endif
endfunction

function! ObjCompleteModeDetect()
	if filereadable("./.objmode")
		let buflist = readfile("./.objmode")
		let buf = join(buflist)
		for line in buflist
			if match(line, "objmode=.*") >= 0
				let mode=strpart(line, 8, strlen(line)-8) 
				call ObjCompleteSetMode(mode)
				break
			endif
		endfor
	endif
endfunction

function! ObjOpenDictFile()
	execute ":edit " s:objfunc_dictonaryfile
endfunction

"call ObjDictionUpdate("~/.vim/after/ftplugin/obj_dictionary.txt", "~/.vim/after/ftplugin/obj_dictionary_extern.txt")
