--require "nvim-metals"

--[[
local lspcfg = require "lspconfig"
vim.lsp.set_log_level("debug")
lspcfg.java_language_server.setup { cmd = {"java-language-server"} }
]]

----------------------------------
-- MISC --------------------------
----------------------------------

local api = vim.api
local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------------------------
-- OPTIONS -----------------------
----------------------------------

vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

----------------------------------
-- KEYBINDINGS -------------------
----------------------------------

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gu", "<cmd>lua vim.lsp.codelens.run()<CR>")
map("n", "<space>o", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "<space>s", [[<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>]])
map("n", "<space>f", [[<cmd>lua require("telescope.builtin").find_files()<CR>]])
map("n", "<space>g", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]])
map("n", "<space>b", [[<cmd>lua require("telescope.builtin").buffers()<CR>]])
map("n", "<space>p", [[<cmd>lua require("telescope.builtin").resume()<CR>]])
-- Add `disable_coordinates=true` when the issue is fixed:
-- https://github.com/nvim-telescope/telescope.nvim/issues/2219
map("n", "<leader>at", [[<cmd>lua require("telescope.builtin").grep_string({prompt_title="Pending TODO's & FIXME's",search="\\b(TODO|FIXME)\\b(?!(:|.*INT-\\d))",use_regex=true,disable_coordinates=true,path_display={"tail"},additional_args={"--pcre2", "--trim"}})<CR>]])
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>ft", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
map("n", "<leader>tf", [[<cmd>NERDTreeFind<CR>]])
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

-- Quickfix list
map("n", "<leader>co", [[<cmd>copen<CR>]])
map("n", "<leader>cc", [[<cmd>cclose<CR>]])
map("n", "<C-j>",      [[<cmd>cnext<CR>]])
map("n", "<C-k>",      [[<cmd>cprev<CR>]])

-- Buffers
map("n", "<leader>bw", [[<cmd>bw<CR>]])
map("n", "<A-j>",      [[<cmd>bn<CR>]])
map("n", "<A-k>",      [[<cmd>bp<CR>]])

-- Misc
map("n", "<leader>w", [[<cmd>setlocal wrap!<CR>]])
map("n", "<leader><leader>", [[<cmd>nohl<CR>]])
map("n", "<leader>oi", [[<cmd>lua require'jdtls'.organize_imports()<CR>]])
map("n", "<C-l>", "2zl")
map("n", "<C-h>", "2zh")

-- completion related settings
local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- None of this made sense to me when first looking into this since there
    -- is no vim docs, but you can't have select = true here _unless_ you are
    -- also using the snippet stuff. So keep in mind that if you remove
    -- snippets you need to remove this select
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- I use tabs... some say you should stick to ins-completion but this is just here as an example
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
})
