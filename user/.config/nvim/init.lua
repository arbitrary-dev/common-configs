require('plugins')
require('nvim-metals')

function set(opt, val)
  val = val or true
  vim.api.nvim_set_option(opt, val)
end

set('number')
set('wrap', false)

function hi(group, val)
  vim.api.nvim_set_hl(0, group, val)
end

hi('Error', {ctermfg='black', ctermbg='red'})
hi('ErrorMsg', {link='Error'})
