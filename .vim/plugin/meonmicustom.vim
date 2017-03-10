let s:customomnilist=[]
let s:customfilelist=[]
let s:oldomnifunc=&omnifunc

function! Customomnicomplete(findstart, base)
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
		for item in s:customomnilist
			let linesplit = split(item, " ")
			if !empty(linesplit)
				if (match(linesplit[0],'^'.a:base)==0)
					if len(linesplit) > 1
						call extend(retOmnilist, [{"word":linesplit[0], "kind":linesplit[1], "info":"info"}])
					else
						call extend(retOmnilist, [{"word":linesplit[0], "kind":"null", "info":"info"}])
					endif
				endif
			endif
		endfor
		let &omnifunc=s:oldomnifunc
		return retOmnilist
    endif
endfunction

function! Customftpinit()
	let linelist=[]
	for filename in s:customfilelist
		let linelist = readfile(filename)
	endfor
	if len(linelist) > 0
		call extend(s:customomnilist, linelist)
	endif
endfunc

function Customcallomni()
	let s:oldomnifunc=&omnifunc
	set omnifunc=Customomnicomplete
	call feedkeys("\<c-x>\<c-o>", "n")
	""return "\<c-x>\<c-o>"
	return ''
endfunction
function Custombackoldomni()
endfunc
"add a new file to custom omni dictionary
function! CustomAddOmniDictionary(filename)
	call add(s:customfilelist, a:filename)
endfunc

"call CustomAddOmniDictionary("/home/zoucao/Downloads/test_dictionary.txt")
call Customftpinit()
imap <c-_>o <c-r>=Customcallomni()<CR>
