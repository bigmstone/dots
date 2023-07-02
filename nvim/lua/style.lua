vim.cmd([[
set cursorline
set number
set background=dark
set title
set showmatch
set colorcolumn=80
]])

require('ayu').setup({ mirage = true })
require('ayu').colorscheme()
