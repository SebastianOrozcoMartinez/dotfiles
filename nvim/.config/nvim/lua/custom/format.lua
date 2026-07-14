require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format" },
    html = { "prettier" },
    css = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})
