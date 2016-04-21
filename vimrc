set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
Plugin 'ascenator/L9', {'name': 'newL9'}

" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

let g:UltiSnipsSnippetDirectories=['UltiSnips']
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
let g:UltiSnipsExpandTrigger = 'ii'
let g:UltiSnipsListSnippets = '<C-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'

"ccal line indentation
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'

"t All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


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
set tags+=/home/zoucao/github/shell/ctag/linux_base-tags
set tags+=/home/zoucao/github/shell/ctag//driver_common-tags
set tags+=/home/zoucao/bin/tag/common/linux_base_plat
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
   cs add ~/github/shell/cscope/cscope.out
   set csverb
   let Cscope_OpenQuickfixWindow = 0
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
"let g:vimwiki_list = [{'path': '~/.vim/vimwiki/',
"            \ 'path_html': '~/.vim/vimwiki/html/',
"            \ 'html_header': '~/.vim/vimwiki/template/header.tpl',}]

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


map <F6> :make clean<CR><CR><CR>
map <F7> :make<CR><CR><CR> :copen<CR><CR>
"map <F8> :make bootimage<CR><CR><CR> :copen<CR><CR>
map <F8>> :cp<CR>
map <F9> :cn<CR>
map <F1> :w<CR><CR><CR>

map <C_c> <ESC>
inoremap { {<ESC>o}<ESC>ko
vnoremap c "+y
vnoremap p "+p
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
"map <C-x>p <ESC>:call Me_pr_func1(1)<CR> 
map <C-n> <ESC>:call Me_pr_func2(1)<CR>
"map <C-x>1 <ESC>:call Me_pr_func3(1)<CR>
map <C-x>q <ESC>:q!<CR>

"map <c-x>f <ESC>o <C-R>=MbufComplete()<CR>
inoremap <c-a> <ESC>:call MjumpBuff()<CR>

"runtime /home/wrsadmin/github/vim/wind.vim
highlight Folded ctermfg=0 ctermbg=7

