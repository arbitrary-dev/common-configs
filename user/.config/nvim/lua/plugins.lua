vim.cmd([[packadd packer.nvim]])
return require('packer').startup(function()

  use 'wbthomason/packer.nvim'
  use 'kyazdani42/nvim-tree.lua'

  -- nvim-metals

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })
  use({
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })
end)
