vim.cmd([[packadd packer.nvim]])
return require('packer').startup(function()
  use { 'kyazdani42/nvim-tree.lua' }
end)
