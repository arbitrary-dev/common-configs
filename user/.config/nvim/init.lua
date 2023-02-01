require('plugins')
require('nvim-metals')

local opt = vim.opt

opt.number = true
opt.wrap = false
opt.updatetime = 1000 -- make references highlighting faster
opt.mouse = '' -- disable mouse
opt.laststatus = 1 -- show statusline only if there are at least two windows

opt.ignorecase = true
opt.smartcase = true

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2

-- Prevents opening of the folds during }{ navigation
-- https://github.com/vim/vim/issues/7134
opt.foldopen:remove{'block'}

-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3281
opt.foldmethod = 'indent'
-- Workaround for:
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1469
--[[
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})
]]

require('telescope').setup({
  defaults = {
    -- Trims absolute path for matches where necessary
    path_display = {"smart"},
  }
})

function hi(group, val)
  vim.api.nvim_set_hl(0, group, val)
end

hi('Error', {ctermfg='black', ctermbg='red'})
hi('ErrorMsg', {link='Error'})
hi('Folded', {ctermfg='darkcyan', ctermbg='black'})
hi('FoldColumnt', {link='Folded'})
hi('LineNr', {ctermfg='darkcyan'})
hi('Pmenu', {ctermfg='white', ctermbg='black'})
hi('PmenuSel', {ctermfg='lightcyan', ctermbg='darkcyan'})

hi('VertSplit', {link='StatusLineNC'})
opt.fillchars = "vert: "
