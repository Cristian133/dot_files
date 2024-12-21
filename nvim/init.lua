local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("keymaps")
require("options")
vim.cmd("source ~/.config/nvim/lua/functions.vim")
vim.cmd("source ~/.config/nvim/lua/keymaps.vim")

require("lazy").setup("plugins")
