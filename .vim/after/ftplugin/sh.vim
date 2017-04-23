let s:objfunclist=[]
let s:objdictionary={}
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
	"let s:objfunclist = readfile(home . "/.vim/after/ftplugin/obj_dictionary.txt")
	let b:adid_ftplugin = 1
python << EOF
import os
import vim
from vimscript import vimobjcomplete
comManger= vimobjcomplete.ObjCompleteManger("/home/zoucao/.vim/after/ftplugin/objcomplete/shell_obj.txt", "/home/zoucao/.vim/after/ftplugin/objcomplete/shell_obj_extern.txt")
comManger.transferToHead()
objextern_dict=vim.bindeval('s:objdictionary');
for obj in comManger.headObjList:
	vim.command("call insert(s:objfunclist,"+"\""+obj.headline+"\""+")")
	extern_str = comManger.getExtern(obj.head)
	if extern_str:
		objextern_dict.update({obj.head : extern_str})
EOF
endfunc

set objfunc=ObjomnicompleteSh

""set omnifunc=Vimomnicomplete
call ObjftpinitSh()
