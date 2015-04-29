set list
let s:mepopupItemResultList = ['abc', 'bbc', 'cbc']

"set omnifunc=TestShow

"function! Test#complete#Main(findstart, base)
function! TestShow(findstart, base)
	let s:testme1=0
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
