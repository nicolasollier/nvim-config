" === Minimal Neovim config with Catppuccin Mocha, Treesitter, CMP, and nvim-lint ===

" Auto-install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" === Plugins ===
call plug#begin('~/.local/share/nvim/plugged')

" Catppuccin theme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Statusline
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Minimap
Plug 'lewis6991/satellite.nvim'

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'lewis6991/gitsigns.nvim' 

" Indentation guide
Plug 'lukas-reineke/indent-blankline.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" AI Completion
Plug 'Exafunction/codeium.nvim'
Plug 'nvim-lua/plenary.nvim'

" Autopairs
Plug 'windwp/nvim-autopairs'

" Linting
Plug 'mfussenegger/nvim-lint'

" Dashboard
Plug 'nvimdev/dashboard-nvim'

call plug#end()

" === General Settings ===
set number relativenumber
set expandtab shiftwidth=2 tabstop=2 smartindent
set wrap
set ignorecase smartcase incsearch hlsearch
set clipboard=unnamedplus
set termguicolors
set noshowmode  " Disable default mode display since lualine will show it
syntax on

" === Lua Config ===
lua << EOF
-- Check if plugins are available before configuring them
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Plugin " .. module .. " not found. Please run :PlugInstall", vim.log.levels.WARN)
    return nil
  end
  return result
end

-- === Catppuccin Theme Setup ===
local catppuccin = safe_require("catppuccin")
if catppuccin then
  catppuccin.setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false,
    term_colors = false,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    no_italic = false,
    no_bold = false,
    no_underline = false,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      dashboard = true,
      indent_blankline = {
        enabled = true,
        scope_color = "",
        colored_indent_levels = false,
      },
    },
  })

  vim.cmd.colorscheme "catppuccin"
else
  vim.cmd.colorscheme "default"
  vim.notify("Catppuccin theme not found. Run :PlugInstall.", vim.log.levels.WARN)
end

-- Load snippets if LuaSnip is available
local luasnip = safe_require("luasnip")
if luasnip then
  require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
end

-- === Lualine Setup ===
local lualine = safe_require("lualine")
if lualine then
  lualine.setup {
    options = {
      theme = 'catppuccin',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'dashboard', 'alpha', 'starter' },
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        'branch',
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
        },
        {
          'diagnostics',
          sources = { 'nvim_diagnostic', 'nvim_lsp' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        },
      },
      lualine_c = {
        {
          'filename',
          file_status = true,
          newfile_status = false,
          path = 1, -- 0: Just the filename, 1: Relative path, 2: Absolute path, 3: Absolute path with ~ for home
          shorting_target = 40,
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '[No Name]',
            newfile = '[New]',
          }
        }
      },
      lualine_x = {
        {
          -- Codeium status
          function()
            local codeium_status = vim.fn['codeium#GetStatusString']()
            if codeium_status ~= '' then
              return ' ' .. codeium_status
            end
            return ''
          end,
          color = { fg = '#a6e3a1' }, -- Catppuccin Mocha green
        },
        'encoding',
        'fileformat',
        'filetype'
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { 'fzf', 'fugitive' }
  }
end

-- === Tree-sitter ===
local treesitter = safe_require("nvim-treesitter.configs")
if treesitter then
  treesitter.setup {
    ensure_installed = { "go", "lua", "python", "javascript", "typescript", "html", "css", "json", "vue", "rust" },
    highlight = { enable = true },
    indent = { enable = true },
  }
end

-- === Indentation Guide ===
local ibl = safe_require("ibl")
if ibl then
  ibl.setup {
    indent = { char = "┊", smart_indent_cap = true },
    scope = { enabled = false },
    exclude = { filetypes = { "help", "terminal", "dashboard" } },
  }
end

-- === CMP Setup ===
local cmp = safe_require("cmp")
if cmp and luasnip then
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
      { name = "codeium" },
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
end

-- === Codeium Setup ===
local codeium = safe_require("codeium")
if codeium then
  codeium.setup({
    enable_chat = true,
  })
end

-- === Auto-pairs ===
local autopairs = safe_require("nvim-autopairs")
if autopairs and cmp then
  autopairs.setup()
  cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
end

-- === Git Signs ===
local gitsigns = safe_require("gitsigns")
if gitsigns then
  gitsigns.setup {
    signs = {
      add          = { text = '▎' },
      change       = { text = '▎' },
      delete       = { text = '▁' },
      topdelete    = { text = '▔' },
      changedelete = { text = '▎' },
      untracked    = { text = '▎' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      
      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})
      
      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})
      
      -- Actions
      map('n', '<leader>gb', function() gs.blame_line{full=true} end)
      map('n', '<leader>gd', gs.diffthis)
    end
  }
end

-- === Satellite Minimap ===
local satellite = safe_require("satellite")
if satellite then
  satellite.setup({
    current_only = false,
    winblend = 50,
    zindex = 40,
    excluded_filetypes = { 'dashboard', 'help', 'fugitive' },
    width = 4,
    handlers = {
      cursor = {
        enable = true,
        overlap = true,
        priority = 1000,
        symbols = { '█', '▓', '▒', '░' },
      },
      search = {
        enable = true,
        signs = { '█', '▓', '▒' },
        priority = 100,
      },
      diagnostic = {
        enable = true,
        signs = { '●', '◉' },
        min_severity = vim.diagnostic.severity.WARN,
        priority = 50,
      },
      gitsigns = {
        enable = true,
        signs = { '█', '▓', '▒' },
        priority = 30,
      },
      marks = {
        enable = true,
        show_builtins = false,
        priority = 40,
      },
    },
  })
end

-- === Linting ===
local lint = safe_require("lint")
if lint then
  lint.linters_by_ft = {
    go = { "golangcilint" },
    python = { "flake8" },
    javascript = { "eslint" },
    typescript = { "eslint" },
    vue = { "eslint" },
    lua = { "luacheck" },
    sh = { "shellcheck" },
  }

  lint.linters.eslint.args = {
    "--format", "json",
    "--stdin",
    "--stdin-filename", function() return vim.fn.expand("%:p") end,
  }

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
    callback = function() 
      lint.try_lint()
    end,
  })
end

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    enabled = true,
    source = "if_many",
    prefix = "●",
  },
  signs = {
    active = {
      { name = "DiagnosticSignError", text = "✘" },
      { name = "DiagnosticSignWarn", text = "▲" },
      { name = "DiagnosticSignHint", text = "⚑" },
      { name = "DiagnosticSignInfo", text = "❯" },
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- === Dashboard Setup ===
local dashboard = safe_require("dashboard")
if dashboard then
  dashboard.setup {
    theme = 'hyper',
    config = {
      header = {
  '',
  '        ██████████████████████████████████',
  '     ████▀▀▀░░░░░░░░░░░░░░░░░░░▀▀▀█████████',
  '   ███▀░░░      ▒▒▒▒▒▒▒▒▒▒▒▒      ░░░▀█████',
  '  ██░░   ░░▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓░░   ░░███',
  ' ██░░  ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓  ░░██',
  ' ██░░ ▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓ ░░██',
  ' ██░░ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░██',
  ' ██░░ ▒▒▒▒██▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▒▒▒▒▒░░░██',
  ' ██░░ ░▒▒████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓████▒▒░░░░░░██',
  ' ██░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░██',
  ' ██░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░██',
  '  ██░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░███',
  '   ███░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░████',
  '     ████░░░░░░░░░░░░░░░░░░░░░░░░░█████',
  '        █████████████████████████████',
  '',
        '    🦠 Let\'s Blob some shit! 🦠 ',
        '',
      },
      shortcut = {
        { desc = '󰊳 Update Plugins', group = '@property', action = 'PlugUpdate', key = 'u' },
        { desc = ' Find File', group = 'Label', action = 'Files', key = 'f' },
        { desc = ' Recent Files', group = 'Label', action = 'History', key = 'r' },
        { desc = ' Find Text', group = 'Number', action = 'Rg', key = 't' },
        { desc = ' New File', group = 'Action', action = 'enew', key = 'n' },
        { desc = ' Config', group = 'Action', action = 'edit ~/.config/nvim/init.vim', key = 'c' },
        { desc = '󰗼 Quit', group = 'Action', action = 'quit', key = 'q' },
      },
      footer = {}
    }
  }
end
EOF

let mapleader = " "

" === FZF Configuration ===
set rtp+=/opt/homebrew/opt/fzf
let $FZF_DEFAULT_OPTS = '--height 40% --layout=default --border --bind=ctrl-j:down,ctrl-k:up,ctrl-d:page-down,ctrl-u:page-up,ctrl-a:select-all,ctrl-t:toggle'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_buffers_jump = 1

nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>d :lua require('lint').try_lint()<CR>

" === Create New File Function ===
nnoremap <C-n> :e <C-R>=expand('%:p:h').'/'<CR>
nnoremap <leader>n :e 

" === Prettier Format on Save ===
function! PrettierFormat()
  if executable('prettier')
    let l:current_pos = getpos('.')
    silent! execute '%!prettier --stdin-filepath ' . shellescape(expand('%'))
    if v:shell_error
      undo
      echo "Prettier formatting failed"
    endif
    call setpos('.', l:current_pos)
  endif
endfunction

autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.vue,*.css,*.scss,*.html,*.json,*.md call PrettierFormat()

highlight SignColumn guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight CursorLineNr guibg=NONE ctermbg=NONE
