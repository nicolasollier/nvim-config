local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
  s("div", {
    t("<div>"), i(1), t("</div>")
  }),
  
  s("p", {
    t("<p>"), i(1), t("</p>")
  }),
  
  s("span", {
    t("<span>"), i(1), t("</span>")
  }),
  
  s("h1", {
    t("<h1>"), i(1), t("</h1>")
  }),
  
  s("h2", {
    t("<h2>"), i(1), t("</h2>")
  }),
  
  s("h3", {
    t("<h3>"), i(1), t("</h3>")
  }),
  
  s("h4", {
    t("<h4>"), i(1), t("</h4>")
  }),
  
  s("button", {
    t("<button>"), i(1), t("</button>")
  }),
  
  s("a", {
    t('<a href="'), i(1), t('">'), i(2), t("</a>")
  }),
  
  s("divc", {
    t('<div class="'), i(1), t('">'), i(2), t("</div>")
  }),
  
  s("pc", {
    t('<p class="'), i(1), t('">'), i(2), t("</p>")
  }),
  
  s("spanc", {
    t('<span class="'), i(1), t('">'), i(2), t("</span>")
  }),
  
  s("buttonc", {
    t('<button class="'), i(1), t('">'), i(2), t("</button>")
  }),
  
  s("divi", {
    t('<div id="'), i(1), t('">'), i(2), t("</div>")
  }),

  s("img", {
    t('<img src="'), i(1), t('" alt="'), i(2), t('" />')
  }),
  
  s("input", {
    t('<input type="'), c(1, {
      t("text"),
      t("email"),
      t("password"),
      t("number"),
      t("checkbox"),
      t("radio"),
      t("submit"),
      t("button")
    }), t('" />'), i(2)
  }),
  
  s("br", {
    t("<br />")
  }),
  
  s("hr", {
    t("<hr />")
  }),
  
  
  s("form", {
    t('<form action="'), i(1), t('" method="'), c(2, {t("post"), t("get")}), t('">'),
    t({"", "  "}), i(3),
    t({"", "</form>"})
  }),
  
  s("ul", {
    t("<ul>"),
    t({"", "  <li>"}), i(1), t("</li>"),
    t({"", "</ul>"}), i(2)
  }),
  
  s("ol", {
    t("<ol>"),
    t({"", "  <li>"}), i(1), t("</li>"),
    t({"", "</ol>"}), i(2)
  }),
  
  s("li", {
    t("<li>"), i(1), t("</li>")
  }),
  
  s("table", {
    t("<table>"),
    t({"", "  <thead>", "    <tr>", "      <th>"}), i(1), t("</th>"),
    t({"", "    </tr>", "  </thead>", "  <tbody>", "    <tr>", "      <td>"}), i(2), t("</td>"),
    t({"", "    </tr>", "  </tbody>", "</table>"}), i(3)
  }),
  
  
  s("section", {
    t("<section>"), i(1), t("</section>")
  }),
  
  s("article", {
    t("<article>"), i(1), t("</article>")
  }),
  
  s("header", {
    t("<header>"), i(1), t("</header>")
  }),
  
  s("footer", {
    t("<footer>"), i(1), t("</footer>")
  }),
  
  s("nav", {
    t("<nav>"), i(1), t("</nav>")
  }),
  
  s("main", {
    t("<main>"), i(1), t("</main>")
  }),
  
  s("aside", {
    t("<aside>"), i(1), t("</aside>")
  }),
  
  
  s("html5", {
    t("<!DOCTYPE html>"),
    t({"", '<html lang="fr">'}),
    t({"", "<head>"}),
    t({"", '  <meta charset="UTF-8">'}),
    t({"", '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'}),
    t({"", "  <title>"}), i(1, "Document"), t("</title>"),
    t({"", "</head>"}),
    t({"", "<body>"}),
    t({"", "  "}), i(2),
    t({"", "</body>"}),
    t({"", "</html>"}), i(0)
  }),
}
