let s:count=0
let s:r_start=0 " check the while back to the start of buffer
function! Me_zf_funcs(type)
	" 折叠c文件所有函数和数据
	let s:count = 0

	call search("{")
	let b:r_start = line('.') " first search {, recoard the line for checking the end of while loop
	execute "normal zf% \<ESC>"

	while 1
		call search("{")
		if line('.') <= b:r_start
			"end loop
			break
		endif
		execute "normal zf% j\<ESC>"
		let s:count += 1
	endwhile
	"echo s:count
endfunction " 


function! Me_pr_func1(type)
	execute "normal koprintk(\"zz \%s +\\n\", __func__);\<ESC>j\<ESC>"
	execute "normal oprintk(\"zz \%s -\\n\", __func__);\<ESC>k\<ESC>"
endfunction " 


function! Me_pr_func2(type)
	let s:count=1
	execute "normal is:count ESC>"
endfunction " 

function! Me_Tag(TagType)
	if a:TagType == "kernel"
		set tags&
		set tags+=/home/wrsadmin/bin/tag/common/out/linux_base-tags
		set tags+=/home/wrsadmin/bin/tag/common/out/driver_common-tags
		set tags+=/home/wrsadmin/bin/tag/common/linux_base_plat
		cs reset
   		cs add /home/wrsadmin/bin/tag/cscope.out
	elseif a:TagType == "user"
	endif
	for tagname in a:tags
		echo tagname
	endfor
endfunction
