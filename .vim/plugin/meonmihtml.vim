
""set dictionary-=~/.vim/after/ftplugin/html_funclist.txt dictionary+=~/.vim/after/ftplugin/html_funclist.txt
""set iskeyword+=>
""set complete-=k complete+=k

""autocmd BufNewFile *  setlocal filetype=html
let s:htmlomnilist=[]

function! Htmlomnicomplete(findstart, base)
    if a:findstart == 1
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~# '[a-zA-Z0-9:_\@\-\<\>]'
		  let start -= 1
		endwhile
		return start

    "findstart = 0 when we need to return the list of completions
    else
		""let retOmnilist =[{"word":"abc","kind":"vasfasf","info":"变量"}, {"word":"eee","info":"也是变量"}]
		let retOmnilist =[]

        let line = getline('.')
        let idx = col('.')
		for item in s:htmlomnilist
			let linesplit = split(item, " ")
			if !empty(linesplit)
				if (match(linesplit[0],'^'.a:base)==0)
					""echoe linesplit[0] linesplit[1]
					call extend(retOmnilist, [{"word":linesplit[0], "kind":linesplit[1], "info":"info"}])
				endif
			endif
		endfor
		return retOmnilist
    endif
endfunction

function! Htmlftpinit()
	let s:htmlomnilist= readfile("/home/zoucao/.vim/after/ftplugin/html_funclist.txt")
endfunc

""set omnifunc=Htmlomnicomplete
call Htmlftpinit()
