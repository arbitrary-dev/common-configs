--local cmd = vim.cmd
--
----------------------------------
-- PLUGINS -----------------------
----------------------------------
--cmd([[packadd packer.nvim]])
--[[
require("packer").startup(function(use)

  use "preservim/nerdtree"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = { {"nvim-lua/plenary.nvim"} }
  }

  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })
  --[[
  use({
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })

  --TODO update setup()
  --use "lukas-reineke/indent-blankline.nvim"

  --use "neovim/nvim-lspconfig"

  --use 'mfussenegger/nvim-jdtls'

  use {
    'Julian/lean.nvim',
    ft = "lean",

    requires = {
      {'neovim/nvim-lspconfig'},
      {'nvim-lua/plenary.nvim'},
      -- you also will likely want nvim-cmp or some completion engine
    },
  }
end)
]]

return {

  'neovim/nvim-lspconfig',

  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
  },

  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      -- you also will likely want nvim-cmp or some completion engine
    },

    -- see details below for full configuration options
    opts = {
      lsp = {
        on_attach = on_attach,
      },
      mappings = true,
    }
  },
}
