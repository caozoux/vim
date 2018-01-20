if exists("b:vim_did_ftplugin")
  finish
endif
let b:vim_did_ftplugin = 1  " Don't load another plugin for this buffer

let home=system("echo $HOME")
let home=strpart(home,0, len(home)-1)
let s:objdiction_file = "~/.vim/after/ftplugin/objcomplete/vim/vim_obj.note"
let s:objdiction_exfile = "~/.vim/after/ftplugin/objcomplete/vim/vim_obj_extern.note"
call ObjDictionUpdate(s:objdiction_file, s:objdiction_exfile)

inoremap $ <ESC>:normal! a${}<ESC>ha
