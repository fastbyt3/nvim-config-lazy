local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("go", {
	s("struct", {
		t("type "),
		i(1, ""),
		t(" struct {\n"),
		t("\t"),
		i(0),
		t("\n"),
		t("}"),
	}),
})
