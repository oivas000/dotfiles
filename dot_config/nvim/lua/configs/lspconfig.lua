require("nvchad.configs.lspconfig").defaults()

local servers = {
  "pyright",              -- Python
  "rust-analyzer",        -- Rust
  "clangd",               -- C/C++
  "html",                 -- HTML
  "cssls",                -- CSS
  "tsserver",             -- JavaScript/TypeScript
  "gopls",                -- Go
  "lua-ls",               -- Lua
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
