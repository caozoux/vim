function! JumToPatchItemHead(type)
	"跳到patchitem的开头
	line = getline(".")
	if line[0] != "@"
		number=search("^@@.*", b)
	endif
endfunction
