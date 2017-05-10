function! CompileSass()
	let error=1
	let sassfilename=""
	let listv=readfile(".sassVim")
	let sassfilename=listv[0]
python << EOF
import os
import vim
filename=""
if os.path.isfile("./.sassVim"):
	ret = open(".sassVim").readlines()
	filename = ret[0]
	cmdSassVim= "scss --update "+filename[:-1]+" | grep error"
	ret = os.popen(cmdSassVim).read()
	if len(ret) <3 :
		vim.command("let error=0")
	else:
		vim.command("let error=1")
else:
	vim.command("let error=1")
EOF
	if error !=0
		if sassfilename[0] == "_"
			return
		endif
		execute ":!scss --update ". sassfilename
	endif
endfunction

set iskeyword+=-
map <F5> :!ctags --options=$HOME/.vim/ctags/scss.config  -R .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags --options=$HOME/.vim/ctags/scss.config  -R .<CR><CR> :TlistUpdate<CR>

map <c-x>b :call CompileSass() <CR>
imap <c-x>b <ESC>:call CompileSass() <CR>
map <C-x>w <ESC>:w <CR>:call CompileSass() <CR>
