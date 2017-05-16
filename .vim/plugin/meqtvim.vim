function! QtMake()
	python import sys
	python lines = open(".qtVim").read()
	python print(lines)
	python vim.command(lines)
endfunction 

func! MakeSelect()
python import sys
python import os
python << EOF
if os.path.isfile("./.qtVim"):
	isQtVim=1
	cmdQtVim=open(".qtVim").read()
else:
	isQtVim=0
	cmdQtVim=":make | copen"
EOF
	python vim.command(cmdQtVim)
endfunction 
