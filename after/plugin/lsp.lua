local lsp_zero = require('lsp-zero')

lsp_zero.preset("recommended")

-- Remove this line as .ensure_installed() has been removed
-- lsp_zero.ensure_installed({ ... })

-- Instead, use mason-lspconfig to install and set up LSP servers
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    'eslint',
    'lua_ls',  -- Changed from 'sumneku_lua' to 'lua_ls'
    'rust_analyzer',
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({select = true}),
  ['<C-Space>'] = cmp.mapping.complete(),  -- Fixed typo: '<C-Space'
})

lsp_zero.set_preferences({
  sign_icons = { }
})

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)  -- Changed to vim.diagnostic
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)  -- Changed to vim.diagnostic
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)  -- Changed to vim.diagnostic
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- Remove these lines as they're now handled by mason-lspconfig
-- lsp_zero.setup_servers({'tsserver', 'eslint'})
-- require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())

lsp_zero.setup()

