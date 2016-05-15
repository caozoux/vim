set tags+=./php.tags "add current directory's generated tags file
set omnifunc=csscomplete#CompleteCSS
set omnifunc=htmlcomplete#CompleteTags 
set omnifunc=phpcomplete#CompletePHP


"au FileType php call PHPFuncList()
"function PHPFuncList()
"set dictionary-=~/.vim/after/ftplugin/php_funclist.txt dictionary+=~/.vim/after/ftplugin/php_funclist.txt
"set complete-=k complete+=k
"endfunction

set dictionary-=~/.vim/after/ftplugin/php_funclist.txt dictionary+=~/.vim/after/ftplugin/php_funclist.txt
set complete-=k complete+=k

"PHP语法检查插件 phpcheck.vim
"2014.7.9 PHP保存时自动检查
"2014.8.8 加-n, *.php, 去掉判断, 快捷键
"@author quanhengzhuang
autocmd BufWritePost *.php call PHPSyntaxCheck()

if !exists('g:PHP_SYNTAX_CHECK_BIN')
    let g:PHP_SYNTAX_CHECK_BIN = 'php'
endif

function! PHPSyntaxCheck()
    let result = system(g:PHP_SYNTAX_CHECK_BIN.' -l -n '.expand('%'))
    if (stridx(result, 'No syntax errors detected') == -1)
        echohl WarningMsg | echo result | echohl None
    endif
endfunction

function! InsertPhpTag()
        let pat = '<?'
        let save_cursor = getpos('.')
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'b', save_cursor[1]))
           normal! laphp
		   normal! o?>
		   normal! ko
		endif
        :call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
		normal! llll
endfunction

function! AutoBlacker()
        let pat = ') {'
        let save_cursor = getpos('.')
		let new_position= save_cursor[1] + 1
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'b', save_cursor[1]))
           normal! o}
           normal! ko    
			":call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
        	:call cursor(new_position, save_cursor[2], save_cursor[3])
		else 
			:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
		endif
endfunction

function! AutoChar1()
        let pat = '[/[]'
        let save_cursor = getpos('.')
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'c', save_cursor[1]))
        	:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
           normal! a]
	   endif
endfunction

function! AutoChar2()
        let pat = '["]'
        let save_cursor = getpos('.')
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'c', save_cursor[1]))
        	:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
           normal! a"
	   endif
endfunction

function! AutoChar3()
        let pat = '[(]'
        let save_cursor = getpos('.')
        let result = matchstr(getline(save_cursor[1]), pat)
        if (search(pat, 'c', save_cursor[1]))
        	:call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
           normal! a)
	   endif
endfunction

inoremap ? ?<ESC>:call InsertPhpTag()<CR>a
inoremap { {<ESC>:call AutoBlacker()<CR>
inoremap [ [<ESC>:call AutoChar1()<CR>i
inoremap " "<ESC>:call AutoChar2()<CR>i
inoremap ( (<ESC>:call AutoChar3()<CR>i

