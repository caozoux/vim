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
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
Plugin 'othree/html5.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'spf13/PIV'
Plugin 'ervandew/supertab'
Plugin 'mattn/emmet-vim'
Plugin 'Valloric/YouCompleteMe'
" javascript
Plugin 'pangloss/vim-javascript'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'heavenshell/vim-jsdoc', {'for': ['javascript', 'jsx']}
Plugin 'burnettk/vim-angular'
Plugin 'mxw/vim-jsx' 
Plugin 'marijnh/tern_for_vim'
"Plugin 'tpope/vim-pathogen'
"Plugin 'davidhalter/jedi-vim'   "python autocomplete plugin 
Plugin 'jnurmine/Zenburn'       "color config
Plugin 'altercation/vim-colors-solarized' "color config
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}   "powerline
Plugin 'pboettch/vim-cmake-syntax' "cmake syntax
Plugin 'vim-scripts/Conque-GDB'

let g:UltiSnipsSnippetDirectories=['UltiSnips']
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
let g:UltiSnipsExpandTrigger = 'ii'
let g:UltiSnipsListSnippets = '<C-tab>'
"let g:UltiSnipsJumpForwardTrigger = '<tab>'
"let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'

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
"set completeopt=menu,menuone
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

"----------------------------------ctags setting------------------------------
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags
set tags+=./tags "add current directory's generated tags file
"-- Taglist setting --
let Tlist_Ctags_Cmd='ctags'
let Tlist_Use_Right_Window=1 
let Tlist_Show_One_File=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Process_File_Always=1
let Tlist_Inc_Winwidth=0




"------------------------- WinManager setting -----------------------------
let g:winManagerWindowLayout='FileExplorer|TagList'


"------------------------- MiniBufferExplorer -----------------------------
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMapCTabSwitchWindows = 1
let g:miniBufExplModSelTarget = 1 

"------------------------------- cscope ------------------------------------
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
endif


" ----------------------------------------------------------------------------
" YouCompleteMe
" ----------------------------------------------------------------------------
let g:acp_behaviorKeywordLength = 3

" ----------------------------------------------------------------------------
" syntastic
" ----------------------------------------------------------------------------
let g:syntastic_error_symbol='✘'
let g:syntastic_warning_symbol='❗'
let g:syntastic_style_error_symbol='»'
let g:syntastic_style_warning_symbol='•'
let g:syntastic_check_on_open=1
let g:syntastic_enable_highlighting = 0
let g:syntastic_javascript_checkers = ['eslint']

"--------------------------------showmark set---------------------------------
" Enable ShowMarks
let showmarks_enable = 1
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let showmarks_ignore_type = "hqm"
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1 

"-------------------------------- powerline --------------------------------------
set guifont=PowerlineSymbols\ for\ Powerline
set nocompatible
set t_Co=256
let g:Powerline_symbols = 'fancy'

"-------------------------------- vimwiki ------------------------------------
let g:vimwiki_use_mouse = 1
"let g:vimwiki_list = [{'path': '~/.vim/vimwiki/',
"           \ 'libse': '~/.vim/vimwiki/libse/',}]
let wiki_root = {}
let wiki_root.path = '~/vimwiki/'
let wiki_root.path_html = '~/vimwiki/html/'

let wiki_libse = {}
let wiki_libse.path = '~/vimwiki/libse/'
let wiki_libse.path_html = '~/vimwiki/libse/html/'

let g:vimwiki_list = [wiki_root, wiki_libse]

"set expandtab
set tabstop=4
set shiftwidth=4
"tab = 4 space
"set softtabstop=4
set autoindent
set smartindent

set nocompatible
let python_highlight_all=1
syntax on

set number
set autowrite
set autoread
au CursorHold * checktime

set clipboard=unnamed
set clipboard=unnamedplus

"----------------------------- highlight ----------------------------------
highlight Folded ctermfg=0 ctermbg=7
set cursorline
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white  
colorscheme zenburn

"---------------------------------------------------------------------------
"  now use jedi for python complete, forget it
"---------------------------------------------------------------------------
"filetype plugin indent on
"autocmd FileType python setlocal et sta sw=4 sts=4
"filetype plugin on
"let g:pydiction_location='~/.vim/after/ftplugin/pydiction/complete-dict'
"set ofu=syntaxcomplete
"autocmd FileType python　set omnifunc=pythoncomplete#Complete 
"autocmd FileType python runtime! autoload/pythoncomplete.vim

au BufRead,BufNewFile *.patch set filetype=patch

map <F6> :make clean<CR><CR><CR>
"map <F7> :make<CR><CR><CR> :copen<CR><CR>
map <F7> :call MakeSelect() <CR><CR>
"map <F8> :make bootimage<CR><CR><CR> :copen<CR><CR>
map <F8>> :cp<CR>
map <F9> :cn<CR>
map <F1> :w<CR><CR><CR>
inoremap [ <ESC>:call AutoBlacker("[", 0)<CR><ESC>ha
inoremap " <ESC>:call AutoBlacker("\"", 1)<CR><ESC>ha
inoremap ' <ESC>:call AutoBlacker("'", 1)<CR><ESC>ha
inoremap ( <ESC>:call AutoBlacker("(", 0)<CR><ESC>ha

map <C_c> <ESC>
vnoremap c "+y
vnoremap p "+p
inoremap <C-d> <RIGHT><DEL>

map <C-x>w <ESC>:w<CR>
map <C-x>x <ESC>:wq<CR>
map <C-x>q <ESC>:q!<CR>
map <C-x>z <ESC>:call ObjOpenDictFile()<CR>
map <C-n>  <ESC>:call Me_pr_func2(1)<CR>
map <C-x>q <ESC>:q!<CR>
map <C-x>l <ESC>:sourc ~/.vim/plugin/metest.vim<CR>
map <C-x>k <ESC>:call PyMeTest()<CR>

"runtime /home/wrsadmin/github/vim/wind.vim
map <C-x>v <ESC>:call Patch_vsplit_open()<CR>
map <C-x>c <ESC>"+p
imap <c-x><c-n> a<ESC>x:call PrintkPast()<CR>
map  <c-x><c-n> oa<ESC>x:call PrintkPast()<CR>

"let g:EclimTodoSearchExtensions = ['java', 'py', 'php', 'jsp', 'xml', 'html']
"set autcompletion for Eclim
"
let g:SuperTabDefaultCompletionType = 'context'
"youcompleteme  默认tab  s-tab 和自动补全冲突
"let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示

let g:ycm_collect_identifiers_from_tags_files=1 " 开启 YCM 基于标签引擎
let g:ycm_min_num_of_chars_for_completion=2 " 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0  " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>    "force recomile with syntastic
"nnoremap <leader>lo :lopen<CR> "open locationlist
"nnoremap <leader>lc :lclose<CR>    "close locationlist
inoremap <leader><leader> <C-x><C-o>
let g:acp_behaviorJavaEclimLength = 3

"function MeetsForJavaEclim(context)
"  return g:acp_behaviorJavaEclimLength >= 0 &&
"        \ a:context =~ '\k\.\k\{' . g:acp_behaviorJavaEclimLength . ',}$'
"endfunction

function MeetsForJavaEclim(context)
endfunction

let g:acp_behavior = {
    \ 'java': [{
      \ 'command': "\<c-x>\<c-u>",
      \ 'completefunc' : 'eclim#java#complete#CodeComplete',
      \ 'meets'        : 'MeetsForJavaEclim',
    \ }]
  \ }

"let  g:acp_behaviorJavaEclimLength = g:acp_behaviorJavaEclimLength
let g:user_emmet_expandabbr_key = '<C-e>'
"let g:user_emmet_expandabbr_key='<Tab>'
"imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

"加入note作为note filetype, objfunc将会使用他
augroup filetypedetect
au BufNewFile,BufRead *.note	setf note
augroup END
