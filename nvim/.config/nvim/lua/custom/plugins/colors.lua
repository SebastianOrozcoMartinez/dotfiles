-- ~/.config/nvim/lua/custom/plugins/colors.lua
return {
  {
    "norcalli/nvim-colorizer.lua",
    lazy = false,
    config = function()
      require("colorizer").setup(
        { "*" },
        {
          RGB      = true,
          RRGGBB   = true,
          names    = true,
          RRGGBBAA = true,
          rgb_fn   = true,
          hsl_fn   = true,
          tailwind = false,
          mode     = "background", -- colored blocks in the background
        }
      )
    end
  }
}
