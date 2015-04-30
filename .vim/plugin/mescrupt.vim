
let s:mepopupItemtList = ['printk("zz %s \n", __func__);', 'dev_dbg(dev, "%s\n", __func__)', 'dev_info(dev, "%s\n", __func__)']
let s:mepopupItemResultList=s:mepopupItemtList

function! Mecomplete(findstart, base)
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

	let b:mefilter="v:val =~ ". "\"" . cword . "\""
	let s:mepopupItemResultList =s:mepopupItemResultList
	call filter(s:mepopupItemResultList, b:mefilter)
    if a:findstart == 1
		if len(s:mepopupItemResultList) > 0 
			"idx+1 表示补全内容的启动insert地方
			return idx+1
		else
			return 0
		endif
    else
		return s:mepopupItemResultList
    endif
	"call filter(s:mepopupItemResultList, 'v:val =~ "pr"')
	"execute "python vimcomplete('" . cword . "', '" . a:base . "')"
	"return s:mepopupItemResultList
endfunc

set completefunc=Mecomplete
