vim.g.mapleader=" "
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.keymap.set("n","<leader>s",vim.cmd.w)
vim.keymap.set("n","<leader>v",vim.cmd.vsplit)
--send target onto oblivion
vim.keymap.set("x","<leader>p","\"_dP")
vim.keymap.set("n","dd","\"_dd")
--remap so it actually deletes by pointing to void register
vim.keymap.set("n","<C-b>", "\"_bdiw")
vim.keymap.set("n","diw", "\"_diw")
vim.keymap.set("n","dw", "\"_dw")
vim.keymap.set("n","d$", "\"_d$")
vim.keymap.set("n","d0", "\"_d0")
vim.keymap.set("n","df", "\"_df")
vim.keymap.set("n","di\"", "\"_di\"")
vim.keymap.set("n","di'", "\"_di'")
