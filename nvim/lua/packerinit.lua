return require('packer').startup(function(use)
    -- Base
    use 'wbthomason/packer.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' },
    }
    use 'neoclide/coc.nvim'
    use 'majutsushi/tagbar'
    -- use 'w0rp/ale'
    -- use 'vim-airline/vim-airline'

    -- Helpers
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'lukas-reineke/indent-blankline.nvim'
    -- use 'wincent/Command-T'
    -- use 'tpope/vim-fugitive'
    -- use 'tpope/vim-repeat'
    -- use 'tpope/vim-surround'
    -- use 'airblade/vim-gitgutter'
    -- use 'tmhedberg/matchit'
    -- use 'junegunn/goyo.vim'
    -- use 'junegunn/limelight.vim'
    -- use 'dominikduda/vim_current_word'
    -- use 'mg979/vim-visual-multi'

    -- Language Specific
    use 'rust-lang/rust.vim'
    -- use 'moll/vim-node'
    -- use 'elzr/vim-json'
    -- use 'tikhomirov/vim-glsl'
    -- use 'ziglang/zig.vim'
    -- use 'liuchengxu/graphviz.vim'

    -- Colors
    -- use 'loctvl842/monokai-pro.nvim'
    -- use 'morhetz/gruvbox'
end)
