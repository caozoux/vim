if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1  " Don't load another plugin for this buffer

let s:objfunclist=[]
let s:objdictionary={}
let s:objdiction_file=""
let s:objdiction_exfile=""
set iskeyword+=#
function! ObjomnicompleteSh(findstart, base)
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

func! ObjftpinitSh()
	let home=system("echo $HOME")
	let home=strpart(home,0, len(home)-1)
	let s:objdiction_file = home."/.vim/after/ftplugin/objcomplete/shell_obj.txt")
	let s:objdiction_exfile = home."/.vim/after/ftplugin/objcomplete/shell_obj_extern.txt")
python << EOF
import os
import vim
from vimscript import vimobjcomplete
home=vim.bindeval("home")
comManger= vimobjcomplete.ObjCompleteManger(home+"/.vim/after/ftplugin/objcomplete/shell_obj.txt", home+"/.vim/after/ftplugin/objcomplete/shell_obj_extern.txt")
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
	set objfunc=ObjomnicompleteSh
endif

"更新当前的objfunc的字典
function! ObjomnicompleteShUpdate()
	let s:objfunclist=[]
	let s:objdictionary={}
	call ObjftpinitSh()
endfunction

"打开当前的obj dictionary files,编辑并保存"
function! ObjomnicompleteShOpen()
	execute ":edit "s:objdiction_file
	execute ":edit "s:objdiction_exfile
endfunction

call ObjftpinitSh()
