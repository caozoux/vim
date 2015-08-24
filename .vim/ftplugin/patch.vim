set list
let s:count=0
let s:r_start=0 " check the while back to the start of buffer
function! TestStart(type) " 
	let s:count = 0

	call search("{")
	let b:r_start = line('.') " first search {, recoard the line for checking the end of while loop
	execute "normal zf% \<ESC>"

	while s:count <5
		call search("{")
		if line('.') <= b:r_start  
			"end loop
			break
		endif
		execute "normal zf% \<ESC>"
		let s:count += 1
	endwhile
	"echo s:count
endfunction " 
