require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Quit all buffers & exit Neovim (Ctrl + Shift + Q)
map({ "n", "i", "v" }, "<C-S-q>", function()
  vim.cmd("%bd!")  -- delete all buffers
  vim.cmd("qa!")   -- quit Neovim
end, { desc = "Quit all buffers and exit" })
