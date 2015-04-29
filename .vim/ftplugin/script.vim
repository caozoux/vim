set list
let s:mepopupItemResultList = ['abc', 'bbc', 'cbc']

"set omnifunc=TestShow

"function! Test#complete#Main(findstart, base)
function! TestShow(findstart, base)
	let s:testme1=0
	return s:mepopupItemResultList
endfunc

function! TestShow2(findstart, base)
	let s:testme1=0
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
        "vim no longer moves the cursor upon completion... fix that
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
        execute "python vimcomplete('" . cword . "', '" . a:base . "')"
        return g:pythoncomplete_completions
    endif
	return s:mepopupItemResultList
endfunc

function Show(start, ...)
  echohl Title
  echo "start is " . a:start
  echohl None
  let index = 1
  while index <= a:0
    echo "  Arg " . index . " is " . a:{index}
    let index = index + 1
  endwhile
  set omnifunc=TestShow
  echo ""
endfunction
