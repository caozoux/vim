let s:objhtmlfunclist=[]
let g:objhtmldictionary={}
"set iskeyword+=#
function! Objhtmlomnicomplete(findstart, base)
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
		for item in s:objhtmlfunclist
			let linesplit = split(item, "\t")
			if (match(linesplit[0],'^'.a:base)==0)
				if len(linesplit) > 1
					echo linesplit[0]
					if has_key(g:objhtmldictionary, linesplit[0])
						call extend(retOmnilist, [{"word":linesplit[0], "kind":linesplit[1], "info":g:objhtmldictionary[linesplit[0]]}])
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

func! Objhtmlftpinit()
	let home=system("echo $HOME")
	let home=strpart(home,0, len(home)-1)
	let b:adid_ftplugin = 1
python << EOF
import os
import vim
from vimscript import vimobjcomplete
comManger= vimobjcomplete.ObjCompleteManger("/home/zoucao/.vim/after/ftplugin/objcomplete/htmlobj_dictionary.txt", "/home/zoucao/.vim/after/ftplugin/objcomplete/htmlobj_dictionary_extern.txt")
comManger.transferToHead()
objextern_dict=vim.bindeval('g:objhtmldictionary');
for obj in comManger.headObjList:
	vim.command("call insert(s:objhtmlfunclist,"+"\""+obj.headline+"\""+")")
	extern_str = comManger.getExtern(obj.head)
	if extern_str:
		objextern_dict.update({obj.head : extern_str})
EOF
endfunc

set objfunc=Objhtmlomnicomplete 
""set omnifunc=Vimomnicomplete
call Objhtmlftpinit()
