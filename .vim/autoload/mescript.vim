
let g:mecomplete
let s:mepopupItemResultList = ['printk("zz %s \n")'
								'printk("zz %s 1\n")',
								'printk("zz %s 2\n")',
								'printk("zz %s 3\n")']
function! TestShow(findstart, base)
	let s:testme1=0
	return s:mepopupItemResultList
endfunc

function Meshow(start, ...)
	if start == 1:
		  let g:mecomolete=omnifunc
		  set omnifunc=TestShow
	else
		omnifunc=g:mecomolete
	endif

endfunction
