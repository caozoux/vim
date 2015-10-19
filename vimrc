"inoremap ( ()<LEFT>
"inoremap [ []<LEFT>
"inoremap { {}<LEFT> 
"inoremap { {<Enter><Enter>}<UP><RIGHT>


"-- omnicppcomplete setting --
imap <F3> <C-X><C-O>
"imap <F2> <C-X><C-I>
imap <F2> <C-X><C-I>
set completeopt=menu,menuone
let OmniCpp_MayCompleteDot = 1 
let OmniCpp_MayCompleteArrow = 1 
let OmniCpp_MayCompleteScope = 1
let OmniCpp_SelectFirstItem = 2
let OmniCpp_NamespaceSearch = 2
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1
"let OmniCpp_DefaultNamespaces=["std"]
let OmniCpp_ShowScopeInAbbr=1
let OmniCpp_ShowAccess=1 


"supertab
let g:SuperTabRetainCompletionType=2
" 0 - 不记录上次的补全方式
" " 1 - 记住上次的补全方式,直到用其他的补全命令改变它
" " 2 - 记住上次的补全方式,直到按ESC退出插入模式为止
let g:SuperTabDefaultCompletionType="<C-X><C-O>"

"--ctags setting--
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags
set tags+=./tags "add current directory's generated tags file
set tags+=/home/wrsadmin/bin/tag/common/out/linux_base-tags
set tags+=/home/wrsadmin/bin/tag/common/out/driver_common-tags
set tags+=/home/wrsadmin/bin/tag/common/linux_base_plat
"
"-- Taglist setting --
let Tlist_Ctags_Cmd='ctags'
let Tlist_Use_Right_Window=1 
let Tlist_Show_One_File=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Process_File_Always=1
let Tlist_Inc_Winwidth=0




"-- WinManager setting --
let g:winManagerWindowLayout='FileExplorer|TagList'


" -- MiniBufferExplorer --
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMapCTabSwitchWindows = 1
let g:miniBufExplModSelTarget = 1 

if has("cscope")
   set csprg=/usr/bin/cscope     
   set csto=0                   
   set cst                     
   set cscopequickfix=s-,c-,d-,i-,t-,e-
   set nocsverb
   if filereadable("cscope.out")   
       cs add cscope.out        
   elseif $CSCOPE_DB != ""        
        cs add $CSCOPE_DB        
   endif
   cs add /home/wrsadmin/bin/tag/cscope.out
   set csverb
   let Cscope_OpenQuickfixWindow = 0
endif

set tags+=/home/wrsadmin/bin/tag/common/out/linux_base-tags
set tags+=/home/wrsadmin/bin/tag/common/out/driver_common-tags
set tags+=/home/wrsadmin/bin/tag/common/linux_base_plat

map <F4> :cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>
imap <F4> <ESC>:cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>

"get the declare
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"get the define
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"get the function called
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"get the specific string
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
" egrep mode find
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
" find specific file name
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
" find the number of called function in this function
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>


"showmark set
" Enable ShowMarks
let showmarks_enable = 1
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let showmarks_ignore_type = "hqm"
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1 

"vimwiki
let g:vimwiki_use_mouse = 1
let g:vimwiki_list = [{'path': '~/.vim/vimwiki/',
            \ 'path_html': '~/.vim/vimwiki/html/',
            \ 'html_header': '~/.vim/vimwiki/template/header.tpl',}]

"set expandtab
set tabstop=4
set shiftwidth=4
"tab = 4 space
"set softtabstop=4
set autoindent
set smartindent
"显示换行符
"set list

set nocompatible
syntax on

set number
set autowrite

filetype plugin indent on
autocmd FileType python setlocal et sta sw=4 sts=4
filetype plugin on
let g:pydiction_location='~/.vim/after/ftplugin/pydiction/complete-dict'
set ofu=syntaxcomplete
autocmd FileType python　set omnifunc=pythoncomplete#Complete 
autocmd FileType python runtime! autoload/pythoncomplete.vim

au BufRead,BufNewFile *.patch set filetype=patch

"set list if filetype is patch 
"autocmd FileType diff set list

" run file .py
map <F6> :make clean<CR><CR><CR>
map <F7> :make<CR><CR><CR> :copen<CR><CR>
"map <F8> :make bootimage<CR><CR><CR> :copen<CR><CR>
map <F8>> :cp<CR>
map <F9> :cn<CR>
map <F1> :w<CR><CR><CR>

map <C_c> <ESC>
"fold function
inoremap <C-j> <DOWN>
inoremap <C-k> <UP>
inoremap <C-h> <LEFT>
inoremap <C-l> <RIGHT>
inoremap <C-d> <RIGHT><DEL>
"map <C-m> <ESC>"ap<ESC> == entry

map <C-x>w <ESC>:w<CR>
map <C-x>x <ESC>:wq<CR>
map <C-x>q <ESC>:q!<CR>
map <C-x>z <ESC>:call Me_zf_funcs(1)<CR>
"print the _func_+/_func_-
map <C-x>p <ESC>:call Me_pr_func1(1)<CR> 
map <C-n> <ESC>:call Me_pr_func2(1)<CR>
map <C-x>q <ESC>:q!<CR>

"runtime /home/wrsadmin/github/vim/wind.vim
highlight Folded ctermfg=0 ctermbg=7
