-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Telescope: Find files" })

require("custom.lint")
