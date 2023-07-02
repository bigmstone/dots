local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    ----------
    -- Base --
    ----------
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' },
    }
    use 'wbthomason/packer.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'majutsushi/tagbar'
    use 'tpope/vim-commentary'
    use 'yegappan/mru'
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'tpope/vim-fugitive'
    use 'rrethy/vim-illuminate'
    use 'junegunn/goyo.vim'

    -----------------------
    -- Language Specific --
    -----------------------
    use 'rust-lang/rust.vim'
    use 'ziglang/zig.vim'
    use 'tikhomirov/vim-glsl'

    ------------
    -- Colors --
    ------------
    use 'loctvl842/monokai-pro.nvim'


    ---------------
    -- Bootstrap --
    ---------------
    if packer_bootstrap then
        require('packer').sync()
    end
end)
