function! CompileSass()
	let sassfilename = bufname("%")
	"let newscssname = substitute(sassfilename, "\.s[ac]ss", "\.css", 0)
	execute ":!scss --update ". sassfilename
endfunction

set iskeyword+=-
map <F5> :!ctags --options=$HOME/.vim/ctags/scss.config  -R .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags --options=$HOME/.vim/ctags/scss.config  -R .<CR><CR> :TlistUpdate<CR>

map <c-x>b :call CompileSass() <CR>
imap <c-x>b <ESC>:call CompileSass() <CR>

