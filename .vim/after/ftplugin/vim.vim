if exists("b:vim_did_ftplugin")
  finish
endif
let b:vim_did_ftplugin = 1  " Don't load another plugin for this buffer

set omnifunc=Vimomnicomplete
call ObjDictionUpdate("~/.vim/after/ftplugin/obj_dictionary.txt", "~/.vim/after/ftplugin/obj_dictionary_extern.txt")
