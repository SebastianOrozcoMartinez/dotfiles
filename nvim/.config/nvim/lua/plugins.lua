return {
  -- Telescope
  { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Theme
  {
    'RedsXDD/neopywal.nvim',
    config = function()
      require('neopywal').setup()
      vim.cmd('colorscheme neopywal')
    end
  },

  -- Snippets (LuaSnip works with blink.cmp)
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Configure blink.cmp (LazyVim's default)
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = {
        preset = "luasnip"
      },
    }
  },
  { import = "custom.plugins.colors" },
}
