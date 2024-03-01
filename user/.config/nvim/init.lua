--require 'lsp-configs'
--require 'plugins'
-- TODO require 'highlights'

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

opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldenable = false

--[[
require('telescope').setup({
  defaults = {
    -- Trims absolute path for matches where necessary
    path_display = {'smart'},
  }
})
]]
-- Disable folding in Telescope's result window.
--vim.api.nvim_create_autocmd('FileType', { pattern = 'TelescopeResults', command = [[setlocal nofoldenable]] })

-- HIGHLIGHTS

function hi(group, val)
  vim.api.nvim_set_hl(0, group, val)
end

hi('Comment', {ctermfg='darkgray'})
hi('Error', {ctermfg='black', ctermbg='red'})
hi('ErrorMsg', {link='Error'})
hi('ModeMsg', {ctermfg='black', ctermbg='red'})
hi('NonText', {link='LineNr'})
hi('Pmenu', {ctermfg=253, ctermbg=236})
hi('PmenuSel', {ctermfg='black', ctermbg='darkred'})
hi('LineNr', {ctermfg='darkgray'})
hi('Folded', {link='Comment'})
hi('Search', {reverse=true})
hi('Todo', {ctermfg='black', ctermbg='yellow'})
hi('MatchParen', {ctermbg=88})

hi('LspCodeLens', {ctermfg=88})
hi('LspCodeLensSeparator', {ctermfg=52})
hi('LspReferenceRead', {link='MatchParen'})
hi('LspReferenceText', {link='MatchParen'})
hi('LspReferenceWrite', {link='MatchParen'})

--[[
hi('Identifier', {link='Statement'})
hi('scalaInstanceDeclaration', {ctermfg='green'})
hi('scalaNameDefinition', {ctermfg='darkgreen'})
hi('scalaInterpolation', {ctermfg='lightmagenta'})
hi('scalaInterpolationBoundary', {link='scalaInterpolation'})
hi('scalaDocLinks', {ctermfg=32})
hi('scalaParameterAnnotation', {ctermfg='gray'})
hi('scalaParameterAnnotationValue', {link='scalaParameterAnnotation'})
hi('scalaUnimplemented', {link='Todo'})
]]

hi('@lsp.type.class', {link='NONE'})
hi('@lsp.type.namespace', {link='NONE'})

opt.cursorline = true
opt.cursorlineopt = 'number'
hi('CursorLineNr', {ctermfg='black', ctermbg='red'})
hi('Visual', {link='CursorLineNr'})

opt.fillchars = 'vert: '
hi('VertSplit', {link='StatusLineNC'})

--TODO update setup()
--[[
require('indent_blankline').setup {
  show_current_context = true,
  show_current_context_start = false,
}
hi('IndentBlanklineChar', {ctermfg=236})
hi('IndentBlanklineContextChar', {ctermfg='darkred'})
]]

opt.signcolumn = 'number'
vim.fn.sign_define('DiagnosticSignError', {
  text='EE',
  texthl='DiagnosticSignError',
  culhl='CursorLineNr',
  linehl='DiagnosticSignErrorLine',
})
hi('DiagnosticError', {ctermfg='red'})
hi('DiagnosticUnderlineError', {reverse=true, ctermfg='darkred'})
hi('DiagnosticSignError', {ctermfg='red', ctermbg=52})
hi('DiagnosticSignErrorLine', {ctermbg=52})
hi('DiagnosticFloatingError', {ctermfg='lightred'})

hi('ColorColumn', {ctermbg=52})
-- Add 110 line width indicator for Scala sources.
vim.api.nvim_create_autocmd('FileType', { pattern = 'scala', command = [[setlocal colorcolumn=110]] })

vim.api.nvim_create_autocmd('FileType', { pattern = 'java', command = [[setlocal noexpandtab]] })

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

local lsp = require('lspconfig')

lsp.pylsp.setup{}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader><leader>', ':nohl<CR>')
--[[ TODO
-- Quickfix list
map("n", "<leader>co", ':copen<CR>')
map("n", "<leader>cc", ':cclose<CR>')
map("n", "<C-j>",      ':cnext<CR>')
map("n", "<C-k>",      ':cprev<CR>')

-- Buffers
map("n", "<leader>bw", ':bw<CR>')
map("n", "<A-j>",      ':bn<CR>')
map("n", "<A-k>",      ':bp<CR>')

-- Misc
map("n", "<leader>w", ':setlocal wrap!<CR>')
map("n", "<C-l>", "2zl")
map("n", "<C-h>", "2zh")
]]

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>ft', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    --[[ TODO
    -- LSP mappings
    map("n", "gu", ':lua vim.lsp.codelens.run()<CR>')
    map("n", "<space>o", ':lua vim.lsp.buf.document_symbol()<CR>')
    map("n", "<space>s", ':lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>')
    map("n", "<space>f", ':lua require("telescope.builtin").find_files()<CR>')
    map("n", "<space>g", ':lua require("telescope.builtin").live_grep()<CR>')
    map("n", "<space>b", ':lua require("telescope.builtin").buffers()<CR>')
    map("n", "<space>p", ':lua require("telescope.builtin").resume()<CR>')
    -- Add `disable_coordinates=true` when the issue is fixed:
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2219
    map("n", "<leader>at", ':lua require("telescope.builtin").grep_string({prompt_title="Pending TODO\'s & FIXME\'s",search="\\b(TODO|FIXME)\\b(?!(:|.*INT-\\d))",use_regex=true,path_display={"tail"},additional_args={"--pcre2", "--trim"}})<CR>')
    map("n", "<leader>cl", ':lua vim.lsp.codelens.run()<CR>')
    map("n", "<leader>sh", ':lua vim.lsp.buf.signature_help()<CR>')
    map("n", "<leader>rn", ':lua vim.lsp.buf.rename()<CR>')
    map("n", "<leader>ft", ':lua vim.lsp.buf.format{async=true}<CR>')
    map("n", "<leader>ca", ':lua vim.lsp.buf.code_action()<CR>')
    --map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
    map("n", "<leader>aa", ':lua vim.diagnostic.setqflist()<CR>') -- all workspace diagnostics
    map("n", "<leader>ae", ':lua vim.diagnostic.setqflist({severity = "E"})<CR>') -- all workspace errors
    map("n", "<leader>aw", ':lua vim.diagnostic.setqflist({severity = "W"})<CR>') -- all workspace warnings
    map("n", "<leader>d", ':lua vim.diagnostic.setloclist()<CR>') -- buffer diagnostics only
    map("n", "<leader>tf", ':NERDTreeFind<CR>')
    map("n", "<leader>tt", ':lua require("metals.tvp").toggle_tree_view()<CR>')
    map("n", "<leader>tr", ':lua require("metals.tvp").reveal_in_tree()<CR>')

    map("n", "[c", ':lua vim.diagnostic.goto_prev { wrap = false }<CR>')
    map("n", "]c", ':lua vim.diagnostic.goto_next { wrap = false }<CR>')

    map("n", "<leader>oi", ':MetalsOrganizeImports<CR>')

    -- Example mappings for usage with nvim-dap. If you don't use that, you can
    -- skip these
    map("n", "<leader>dc", ':lua require"dap".continue()<CR>')
    map("n", "<leader>dr", ':lua require"dap".repl.toggle()<CR>')
    map("n", "<leader>dK", ':lua require"dap.ui.widgets".hover()<CR>')
    map("n", "<leader>dt", ':lua require"dap".toggle_breakpoint()<CR>')
    map("n", "<leader>dso", ':lua require"dap".step_over()<CR>')
    map("n", "<leader>dsi", ':lua require"dap".step_into()<CR>')
    map("n", "<leader>dl", ':lua require"dap".run_last()<CR>')
    ]]
  end,
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = '◼',
  }
})

--[[
vim.lsp.handlers['textDocument/diagnostic'] = vim.lsp.with(
  vim.lsp.diagnostic.on_diagnostic, {
    virtual_text = {
      spacing = 2,
      prefix = '•',
    },
  }
)
]]
