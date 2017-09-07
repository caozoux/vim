"define syntax

" syntax region Underlined start=/+/ end=/$/
syntax region Number start=/^+/ end=/$/
syntax region String start=/^-/ end=/$/
syntax region Structure start=/diff/ end=/$/
syntax region Comment start=/@@/ end=/$/
syntax region PreCondit start=/--- a/ end=/$/
syntax region PreCondit start=/+++ b/ end=/$/
