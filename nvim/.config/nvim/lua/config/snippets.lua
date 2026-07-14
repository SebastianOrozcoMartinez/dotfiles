-- ~/.config/nvim/lua/config/snippets.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Load VSCode-style snippets if you want
require("luasnip.loaders.from_vscode").lazy_load()

-- Python snippets
ls.add_snippets("python", {
  s("def", { t("def "), i(1, "func_name"), t("("), i(2, "args"), t({ "):", "\t" }), i(0) }),
  s("ifmain", { t("if __name__ == '__main__':"), t({ "", "\t" }), i(0) }),
})

-- Lua snippets
ls.add_snippets("lua", {
  s("req", { t("require("), i(1, '"module"'), t(")") }),
})

ls.add_snippets("html", {
  s("html5", {
    t("<!DOCTYPE html>"),
    t({ "", "<html lang=\"en\">" }),
    t({ "", "<head>" }),
    t({ "", "\t<meta charset=\"UTF-8\">" }),
    t({ "", "\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" }),
    t({ "", "\t<title>" }), i(1, "Document"), t("</title>"),
    t({ "", "</head>" }),
    t({ "", "<body>" }), i(0),
    t({ "", "</body>", "</html>" }),
  }),
  s("linkcss", { t('<link rel="stylesheet" href="'), i(1, "style.css"), t('">') }),
})

-- CSS snippets
ls.add_snippets("css", {
  s("sel", { i(1, "selector"), t({ " {", "\t" }), i(0), t({ "", "}" }) }),
  s("center", { t({ "display: flex;", "justify-content: center;", "align-items: center;" }) }),
})
