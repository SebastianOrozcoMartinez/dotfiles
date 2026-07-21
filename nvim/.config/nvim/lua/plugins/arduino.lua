return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli",
            "arduino-cli",
            "-cli-config",
            vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
            "-clangd",
            "clangd",
            "-fqbn",
            "arduino:avr:uno",
          },
        },
      },
    },
  },
}
