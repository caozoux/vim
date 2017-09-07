"define syntax

" syntax region Underlined start=/+/ end=/$/
syntax region Number start=/^+/ end=/$/
syntax region String start=/^-/ end=/$/
syntax region PreCondit start=/diff/ end=/$/
syntax region Structure start=/@@/ end=/$/
syntax region Comment start=/--- a/ end=/$/
syntax region Comment start=/+++ b/ end=/$/
syntax region Error start=/^`/ end=/$/
