" OmniCppComplete initialization
call omni#cpp#complete#Init()
"inoremap <c-k> <ESC>:call MeFastFormatPrintk()<CR>
""inoremap <c-d> <ESC>:call MeFastFormatLine()<CR>
inoremap <c-d> <ESC>:call MeFastFormatLineV2("printf(\"zz %s ", ", (int)", ":%08 ")<CR>
inoremap <f7> <ESC>:cn<CR>
inoremap <f8> <ESC>:cp<CR>
inoremap { {<ESC>o}<ESC>ko
