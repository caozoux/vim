if exists("b:sh_did_ftplugin")
  finish
endif
let b:sh_did_ftplugin = 1  " Don't load another plugin for this buffer

let home=system("echo $HOME")
let home=strpart(home,0, len(home)-1)
let s:objdiction_file = "~/.vim/after/ftplugin/objcomplete/shell_obj.txt"
let s:objdiction_exfile = "~/.vim/after/ftplugin/objcomplete/shell_obj_extern.txt"
call ObjDictionUpdate(s:objdiction_file, s:objdiction_exfile)
