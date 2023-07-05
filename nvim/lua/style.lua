vim.cmd([[
set cursorline
set number
set background=dark
set title
set showmatch
set textwidth=80
set colorcolumn=+0
]])

require('ayu').setup({ mirage = true })
require('ayu').colorscheme()
