-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.wo.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.wo.foldenable = false
vim.wo.foldcolumn = "auto"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()";

vim.opt.swapfile = false

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { 
      "catppuccin/nvim", name = "catppuccin", priority = 1000,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          highlight = { enable = true },
          ensure_installed = { 
            "css",
            "lua",
            "markdown",
            "markdown_inline",
            "html",
            "javascript",
            "json",
            "jsonc",
            "typescript",
            "tsx",
            "vim",
            "vimdoc",
          }
        })
      end
    },
    {
      "neovim/nvim-lspconfig",
      config = function ()
        local lspconfig = require("lspconfig")

        lspconfig.vtsls.setup({
          single_file_support = true,
          root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json"),
          filetypes = {
            "javascript",
            "javascript.jsx",
            "javascriptreact",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
          },
        })
      end
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function ()
          require("lualine").setup ({
            options = {
              icons_enabled = true,
              theme = "auto",
              component_separators = { left = "|", right = "|"},
              section_separators = { left = "", right = ""},
              disabled_filetypes = {
                statusline = {},
                winbar = {},
              },
              ignore_focus = {},
              always_divide_middle = true,
              always_show_tabline = true,
              globalstatus = false,
              refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
              }
            },
            sections = {
              lualine_a = {"mode"},
              lualine_b = {"diagnostics"},
              lualine_c = {"filename"},
              lualine_x = {"buffers"},
              lualine_y = {},
              lualine_z = {"location"}
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = {"filename"},
              lualine_x = {"location"},
              lualine_y = {},
              lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        })

        require("lualine").setup({
          options = { themes = require("catppuccin.utils.lualine") }
        })
        end
    },
  },

  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})

vim.cmd("colorscheme catppuccin-mocha")
