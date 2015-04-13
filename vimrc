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

"--ctags setting--
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags
set tags+=./tags "add current directory's generated tags file
set tags+=/home/wrsadmin/bin/tag/ti_kernel3.14x/tags
"set tags+=/home/sdh/caozoux/r44b/linux/kernel/tags
"set tags+=/home/sdh/caozoux/tags
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
   if filereadable("cscope.out")   
       cs add cscope.out        
   elseif $CSCOPE_DB != ""        
        cs add $CSCOPE_DB        
   endif
   "cscope -Rbq
   cs add /home/sdh/caozoux/r44b/linux/kernel/cscope.out
   set csverb    
endif
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

"set list if filetype is patch 
"autocmd FileType diff set list

" run file .py
map <F6> :make clean<CR><CR><CR>
map <F7> :make<CR><CR><CR> :copen<CR><CR>
"map <F8> :make bootimage<CR><CR><CR> :copen<CR><CR>
map <F9> :cn<CR>
map <F2> :w<CR><CR><CR>

map <C_c> <ESC>
map <C_x> <ESC>:wq
inoremap <C-j> <DOWN>
inoremap <C-k> <UP>
inoremap <C-h> <LEFT>
inoremap <C-l> <RIGHT>
inoremap <C-d> <RIGHT><DEL>
map <C-n> <ESC>"ap<ESC>
