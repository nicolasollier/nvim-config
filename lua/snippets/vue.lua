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
    t('<form @submit.prevent="'), i(1), t('">'),
    t({"", "  "}), i(2),
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
  
  s("template", {
    t("<template>"),
    t({"", "  "}), i(1),
    t({"", "</template>"}),
    t({"", "", "<script setup>"}),
    t({"", i(2)}),
    t({"", "</script>"}),
    t({"", "", "<style scoped>"}),
    t({"", i(3)}),
    t({"", "</style>"})
  }),
  
  s("vfor", {
    t('<div v-for="'), i(1, "item"), t(' in '), i(2, "items"), t('" :key="'), i(3, "item.id"), t('">'),
    t({"", "  "}), i(4),
    t({"", "</div>"})
  }),
  
  s("vif", {
    t('<div v-if="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</div>"})
  }),
  
  s("vshow", {
    t('<div v-show="'), i(1), t('">'),
    t({"", "  "}), i(2),
    t({"", "</div>"})
  }),
  
  s("vmodel", {
    t('<input v-model="'), i(1), t('" type="'), c(2, {t("text"), t("email"), t("password")}), t('" />')
  }),
  
  s("vclick", {
    t('<button @click="'), i(1), t('">'), i(2), t("</button>")
  }),
}
