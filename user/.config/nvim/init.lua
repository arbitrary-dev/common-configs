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
hi('ModeMsg', {ctermfg='black', ctermbg='red'})
hi('LspCodeLens', {link='Folded'})
hi('LspCodeLensSeparator', {ctermfg='darkred'})
hi('LineNr', {ctermfg='darkgray'})
hi('NonText', {link='LineNr'})
hi('Pmenu', {ctermfg=253, ctermbg=236})
hi('PmenuSel', {ctermfg='black', ctermbg='darkred'})
hi('Comment', {ctermfg='darkgray'})
hi('Folded', {link='Comment'})
hi('Search', {reverse=true})
hi('Todo', {ctermfg='black', ctermbg='darkred'})
hi('MatchParen', {ctermbg=88})
hi('LspReferenceRead', {link='MatchParen'})
hi('LspReferenceText', {link='MatchParen'})
hi('LspReferenceWrite', {link='MatchParen'})

hi('Identifier', {link='Statement'})
hi('scalaInstanceDeclaration', {ctermfg='green'})
hi('scalaNameDefinition', {ctermfg='darkgreen'})
hi('scalaInterpolation', {ctermfg='lightmagenta'})
hi('scalaInterpolationBoundary', {link='scalaInterpolation'})
hi('scalaDocLinks', {ctermfg=32})
hi('scalaParameterAnnotation', {ctermfg='gray'})
hi('scalaParameterAnnotationValue', {link='scalaParameterAnnotation'})

opt.cursorline = true
opt.cursorlineopt = 'number'
hi('CursorLineNr', {ctermfg='black', ctermbg='red'})
hi('Visual', {link='CursorLineNr'})

opt.fillchars = "vert: "
hi('VertSplit', {link='StatusLineNC'})

opt.signcolumn = 'number'
vim.fn.sign_define('DiagnosticSignError', {text='EE', linehl='DiagnosticSignErrorLine'})
hi('DiagnosticError', {ctermfg='red'})
hi('DiagnosticUnderlineError', {ctermbg=52})
hi('DiagnosticSignError', {ctermfg='red', ctermbg=52})
hi('DiagnosticSignErrorLine', {ctermbg=52})
