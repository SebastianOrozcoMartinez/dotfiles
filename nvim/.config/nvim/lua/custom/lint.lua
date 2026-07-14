-- ~/.config/nvim/lua/custom/lint.lua
local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  html = { "htmlhint" }, -- Proper HTML linter
  css = { "stylelint" }, -- Proper CSS linter
  javascript = { "eslint" },
  typescript = { "eslint" },
}

-- Auto-lint on save and text change
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
