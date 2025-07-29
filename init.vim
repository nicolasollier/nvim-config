" === Minimal Neovim config with Ayu, Treesitter, CMP, and nvim-lint ===

" Auto-install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" === Plugins ===
call plug#begin('~/.local/share/nvim/plugged')

Plug 'ayu-theme/ayu-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Indentation guide
Plug 'lukas-reineke/indent-blankline.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Autopairs
Plug 'windwp/nvim-autopairs'

" Linting
Plug 'mfussenegger/nvim-lint'

call plug#end()

" === General Settings ===
set number relativenumber
set expandtab shiftwidth=2 tabstop=2 smartindent
set wrap
set ignorecase smartcase incsearch hlsearch
set termguicolors
syntax on

" === Ayu Theme ===
let ayucolor="mirage"
try
  colorscheme ayu
catch /^Vim\%(\(engine\)\)\?:E185/
  colorscheme default
  echo "Ayu theme not found. Run :PlugInstall."
endtry

" === Lua Config ===
lua << EOF
-- === Tree-sitter ===
require("nvim-treesitter.configs").setup {
  ensure_installed = { "go", "lua", "python", "javascript", "typescript", "html", "css", "json", "vue", "rust" },
  highlight = { enable = true },
  indent = { enable = true },
}

-- === Indentation Guide ===
require("ibl").setup {
  indent = { char = "┊", smart_indent_cap = true },
  scope = { enabled = false },
  exclude = { filetypes = { "help", "terminal", "dashboard" } },
}

-- === CMP Setup ===
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_previous_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
  }),
  sources = {
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }
})

-- CMDline completion
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } })
})

-- === Auto-pairs ===
local autopairs = require("nvim-autopairs")
autopairs.setup()
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

-- === Linting ===
local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
  python = { "flake8" },
  javascript = { "eslint" },
  typescript = { "eslint" },
  lua = { "luacheck" },
  sh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
  callback = function() lint.try_lint() end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
})
EOF

let mapleader = " "
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>d :lua require('lint').try_lint()<CR>

" Optional: Transparent background
" hi Normal guibg=NONE ctermbg=NONE

