-- Set leader key before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazyinit')
require('setup-cmp')
require('setup')
require('base')
require('style')
