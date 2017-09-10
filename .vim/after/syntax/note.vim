syntax match String /#/ contained
""syntax match Debug /^.*#/ contains=String
"syntax match Debug /^.*\t/ contains=Function
syntax match Function +^\S*+ contains=String
syntax region SpecialComment start="^[^\t]" end="$" contains=Function keepend

syntax region Statement start="^\t" end="$"
 "syntax match Debug +^\S*+ contains=Function
