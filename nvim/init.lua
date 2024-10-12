vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {"hrsh7th/cmp-nvim-lsp"},
    {"saadparwaiz1/cmp_luasnip"},
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {"rafamadriz/friendly-snippets"},  
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      dependencies = { 'nvim-lua/plenary.nvim'}
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
     },

  }

}
local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
vim.keymap.set('n', '<C-t>', ':ToggleTerm<CR>', {})




local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"lua", "javascript", "java", "python", "html", "css"},
  highlight = { enable = true },
})
local cmp = require('cmp')
require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })

require("mason").setup()
require("toggleterm").setup()
require("mason-lspconfig").setup({
  ensure_installed = {"lua_ls", "pylyzer", "jdtls", "html", "cssls", "rust_analyzer"}
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
require("lspconfig").pylyzer.setup{}
--require("lspconfig").ast_grep.setup{}
require("lspconfig").lua_ls.setup{}
require("lspconfig").html.setup{}
require("lspconfig").cssls.setup{}
require("lspconfig").jdtls.setup{}
require("lspconfig").rust_analyzer.setup{}
