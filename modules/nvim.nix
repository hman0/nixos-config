{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
       
    ];

    extraLuaConfig = ''
      vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
        callback = function()
          local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
          if not normal.bg then return end
          io.write(string.format("\027]11;#%06x\027\\", normal.bg))
        end,
      })

      vim.api.nvim_create_autocmd("UILeave", {
        callback = function() io.write("\027]111\027\\") end,
      })

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

      vim.g.maplocalleader = "\\"

      require("lazy").setup({
        spec = {
          {
            "catppuccin/nvim",
            name = "catppuccin",
            config = function()
              require("catppuccin").setup({
                flavour = "macchiato"
              })
              vim.cmd("colorscheme catppuccin")
            end,
          },
          {
            "akinsho/bufferline.nvim",
            version = "*",
            dependencies = "nvim-tree/nvim-web-devicons",
            config = function()
              -- Load colors from Catppuccin Macchiato
              local catppuccin = require("catppuccin.palettes").get_palette("macchiato")
              
              -- Pick a background color (catppuccin's "base" or "mantle" are common choices)
              local bg = catppuccin.base  -- or catppuccin.mantle if you want a bit darker
              
              require("bufferline").setup {
                options = {
                  numbers = "ordinal",
                  diagnostics = "nvim_lsp",
                  show_buffer_close_icons = false,
                  show_close_icon = false,
                  always_show_bufferline = true,
                },
                highlights = {
                  fill = { bg = bg },
                  background = { bg = bg },
                  buffer_visible = { bg = bg },
                  buffer_selected = { bg = bg, bold = true },
                  tab = { bg = bg },
                  tab_selected = { bg = bg }, tab_separator = { bg = bg },
                  tab_separator_selected = { bg = bg },
                  tab_close = { bg = bg },
                  close_button = { bg = bg },
                  close_button_visible = { bg = bg },
                  close_button_selected = { bg = bg },
                  separator = { fg = bg, bg = bg },
                  separator_selected = { fg = bg, bg = bg },
                  separator_visible = { fg = bg, bg = bg },
                  modified = { bg = bg },
                  modified_visible = { bg = bg },
                  modified_selected = { bg = bg },
                  duplicate = { bg = bg },
                  duplicate_selected = { bg = bg },
                  duplicate_visible = { bg = bg },
                  indicator_selected = { bg = bg },
                  pick = { bg = bg },
                  pick_selected = { bg = bg },
                  pick_visible = { bg = bg },
                  numbers = { bg = bg },
                  numbers_visible = { bg = bg },
                  numbers_selected = { bg = bg },
                }
              }
            end
          },
          {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            config = function()
              require("nvim-autopairs").setup({})
            end
          }, {
            "nvim-tree/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
              require("nvim-tree").setup()
            end
          }, {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
              require("nvim-treesitter").setup({
                highlight = {
                  enable = true,
                },
              })
            end
          }, {
            "neovim/nvim-lspconfig"
          }, {
            "nvim-telescope/telescope.nvim", tag = "0.1.8",
            dependencies = { {"nvim-lua/plenary.nvim"} }
          }, {
            "nvimdev/dashboard-nvim",
            event = "VimEnter",
            config = function()
              require("dashboard").setup {
                theme = 'hyper',
                config = {
                  week_header = {
                   enable = true,
                  },
                  shortcut = {
                    { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                    {
                      icon = ' ',
                      icon_hl = '@variable',
                      desc = 'Files',
                      group = 'Label',
                      action = function()
                        require('telescope.builtin').find_files({ hidden = true })
                      end,
                      key = 'f',
                    },
                  },
                },
              }
            end,
            dependencies = { {"nvim-tree/nvim-web-devicons"} }
          }, {
            "vyfor/cord.nvim", 
            build = ":Cord update", 
            opts = {
              editor = {
                tooltip = "meow"
              },
              display = {
                theme = "catppuccin",
                flavor = "accent",
              },
            },
          }, {
            "hrsh7th/nvim-cmp",
            dependencies = {
              "hrsh7th/cmp-nvim-lsp",
              "hrsh7th/cmp-buffer",
              "hrsh7th/cmp-path",
              "hrsh7th/cmp-cmdline",
              "L3MON4D3/LuaSnip",
              "saadparwaiz1/cmp_luasnip",
              "rafamadriz/friendly-snippets",
            },
            config = function()
              local cmp = require("cmp") local luasnip = require("luasnip")
              require("luasnip.loaders.from_vscode").lazy_load()

              cmp.setup({
                snippet = {
                  expand = function(args)
                    luasnip.lsp_expand(args.body)
                  end,
                },
                mapping = cmp.mapping.preset.insert({
                  ["<Tab>"]     = cmp.mapping.select_next_item(),
                  ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
                  ["<C-Space>"] = cmp.mapping.complete(),
                  ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                }, {
                  { name = "buffer" },
                  { name = "path" },
                }),
              })
            end,
          }
        }, 
        


        rocks = {
          hererocks = false,
          enabled = true,
        },
        checker = { enabled = true },
      })

      -- ALT+[1,2,3,4,5,6,7,8,9] to switch tabs
      for i = 1, 9 do
        vim.keymap.set('n', '<A-' .. i .. '>', function()
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })
          local target = bufs[i]
          if target then
            vim.api.nvim_set_current_buf(target.bufnr)
          end
        end, { desc = 'Go to buffer ' .. i })
      end

      -- ALT+j to cycle through buffer
      vim.keymap.set('n', '<A-j>', function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        local curr = vim.api.nvim_get_current_buf()
        local i = 1
        for idx, buf in ipairs(bufs) do
          if buf.bufnr == curr then i = idx break end
        end
        local next_idx = (i % #bufs) + 1
        vim.api.nvim_set_current_buf(bufs[next_idx].bufnr)
      end, { desc = "Next buffer" })

      -- ALT+k to cycle through buffer
      vim.keymap.set('n', '<A-k>', function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        local curr = vim.api.nvim_get_current_buf()
        local i = 1
        for idx, buf in ipairs(bufs) do
          if buf.bufnr == curr then i = idx break end
        end
        -- go to previous buffer or wrap around
        local prev_idx = (i - 2) % #bufs + 1
        vim.api.nvim_set_current_buf(bufs[prev_idx].bufnr)
      end, { desc = "Previous buffer" })

      vim.keymap.set({ "n", "i", "v" }, "<Up>", "<Nop>", { noremap = true, silent = true })
      vim.keymap.set({ "n", "i", "v" }, "<Down>", "<Nop>", { noremap = true, silent = true })
      vim.keymap.set({ "n", "i", "v" }, "<Left>", "<Nop>", { noremap = true, silent = true })
      vim.keymap.set({ "n", "i", "v" }, "<Right>", "<Nop>", { noremap = true, silent = true })

      vim.keymap.set("i", "<C-h>", "<Left>")
      vim.keymap.set("i", "<C-l>", "<Right>")
      vim.keymap.set("i", "<C-j>", "<Down>")
      vim.keymap.set("i", "<C-k>", "<Up>")

      vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        callback = function()
          vim.opt_local.formatoptions:remove({'r', 'o'})
        end,
      })

      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
          }
        end

        -- load default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Open file with space bar
        vim.keymap.set("n", "<Space>", api.node.open.edit, opts("Open File"))
      end

      vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n><CR>]], { noremap = true, silent = true })

      require("nvim-tree").setup({
        on_attach = my_on_attach,
      })

      vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        root_markers = { 'Cargo.toml', 'rust-project.json' },
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = 'clippy',
            },
          },
        },
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'rust',
        callback = function(args)
          vim.lsp.enable('rust_analyzer')
        end,
      })

      vim.opt.laststatus = 0
      vim.opt.tabstop = 2    
      vim.opt.shiftwidth = 2    
      vim.opt.expandtab = true 
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.termguicolors = true
      vim.opt.ruler = false
      vim.opt.autoindent = true
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.swapfile = false
    '';
  };
}
