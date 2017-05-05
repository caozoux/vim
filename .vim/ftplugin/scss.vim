set iskeyword+=-,$
map <F5> :!ctags --options=$HOME/.vim/ctags/scss.config  -R .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags --options=$HOME/.vim/ctags/scss.config  -R .<CR><CR> :TlistUpdate<CR>
