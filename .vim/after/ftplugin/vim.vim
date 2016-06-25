if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

"set dictionary-=~/.vim/after/ftplugin/vim_dictionary.txt dictionary+=~/.vim/after/ftplugin/vim_dictionary.txt
"set iskeyword+=>
"set complete-=k complete+=k

let s:vimfunclist=[]
function! Vimomnicomplete(findstart, base)
    if a:findstart == 1
		let line = getline('.')
		let idx = col('.')
		while idx > 0
			let idx -= 1
			let c = line[idx]
			if c =~ '\w'
				continue
			elseif ! c =~ '\.'
				let idx = -1
				break
			else
				break
			endif
		endwhile
     	return idx

    "findstart = 0 when we need to return the list of completions
    else
		""let retOmnilist =[{"word":"abc","kind":"vasfasf","info":"变量"}, {"word":"eee","info":"也是变量"}]
		let retOmnilist =[]
		""let stylesheet = readfile("/home/zoucao/.vim/after/ftplugin/vim_dictionary.txt")

        let line = getline('.')
        let idx = col('.')
        let cword = ''
        while idx > 0
            let idx -= 1
            let c = line[idx]
            if c =~ '\w' || c =~ '\.'
                let cword = c . cword
                continue
            elseif strlen(cword) > 0 || idx == 0
                break
            endif
        endwhile
		echo cword
		for item in s:vimfunclist
			let linesplit = split(item, " ")
			if (match(linesplit[0],'^'.cword)==0)
				call extend(retOmnilist, [{"word":linesplit[0], "kind":linesplit[1], "info":"null"}])
			endif
		endfor
		return retOmnilist
    endif
endfunction

function! VimMDb()
    let result = taglist("^ala\w\+$")
	for item in result
		for key in keys(item)
		  echo key item[key]
		endfor
	endfor
	""call extend(vimlist, ['111', '222'])
endfunction

function! Vimaa()
	let stylesheet = readfile("/home/zoucao/.vim/after/ftplugin/vim_dictionary.txt")
	for item in stylesheet
		let test = split(item)
		for itemal in test 
			echo itemal
		endfor
	endfor
endfunction

func! Vimftpinit()
	echoe "vimftpinit"
	let s:vimfunclist= readfile("/home/zoucao/.vim/after/ftplugin/vim_dictionary.txt")
endfunc

set omnifunc=Vimomnicomplete
call Vimftpinit()

