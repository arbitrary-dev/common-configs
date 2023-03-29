-------------------------------------------------------------------------------
-- These are example settings to use with nvim-metals and the nvim built-in
-- LSP. Be sure to thoroughly read the `:help nvim-metals` docs to get an
-- idea of what everything does. Again, these are meant to serve as an example,
-- if you just copy pasta them, then should work,  but hopefully after time
-- goes on you'll cater them to your own liking especially since some of the stuff
-- in here is just an example, not what you probably want your setup to be.
--
-- Unfamiliar with Lua and Neovim?
--  - Check out https://github.com/nanotee/nvim-lua-guide
--
-- The below configuration also makes use of the following plugins besides
-- nvim-metals, and therefore is a bit opinionated:
--
-- - https://github.com/hrsh7th/nvim-cmp
--   - hrsh7th/cmp-nvim-lsp for lsp completion sources
--   - hrsh7th/cmp-vsnip for snippet sources
--   - hrsh7th/vim-vsnip for snippet sources
--
-- - https://github.com/wbthomason/packer.nvim for package management
-- - https://github.com/mfussenegger/nvim-dap (for debugging)
-------------------------------------------------------------------------------
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
-- PLUGINS -----------------------
----------------------------------

-- Moved to plugins.lua instead.

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
-- Not needed anymore?
--vim.opt_global.shortmess:remove("F"):append("c")

-- LSP mappings
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
map("n", "<leader>at", [[<cmd>lua require("telescope.builtin").grep_string({prompt_title="Pending TODO's & FIXME's",search="\\b(TODO|FIXME)\\b(?!(:|.*INT-\\d))",use_regex=true,path_display={"tail"},additional_args={"--pcre2", "--trim"}})<CR>]])
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>ft", "<cmd>lua vim.lsp.buf.format{async=true}<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
--map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
map("n", "<leader>tf", [[<cmd>NERDTreeFind<CR>]])
map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
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
map("n", "<leader>oi", [[<cmd>MetalsOrganizeImports<CR>]])
map("n", "<C-l>", "2zl")
map("n", "<C-h>", "2zh")

-- completion related settings
-- This is similiar to what I use
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

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
-- metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()

  -- Adds symbol and its references highlighting
  if client.server_capabilities.documentHighlightProvider then
    api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      group = 'lsp_document_highlight',
      callback = vim.lsp.buf.document_highlight
    })
    api.nvim_create_autocmd('CursorMoved', {
      buffer = bufnr,
      group = 'lsp_document_highlight',
      callback = vim.lsp.buf.clear_references
    })

    api.nvim_set_hl(0, 'LspReferenceText', { fg = "#000000", bg = "#FFFFFF", underline = true })
    api.nvim_set_hl(0, 'LspReferenceRead', { fg = "#000000", bg = "#FFFFFF", underline = true })
    api.nvim_set_hl(0, 'LspReferenceWrite', { fg = "#000000", bg = "#FFFFFF", underline = true })
 end
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
