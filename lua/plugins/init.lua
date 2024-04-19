return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    -- Theme
    'sainnhe/everforest',
    priority = 1000,
    config = function()
      -- vim.g.everforest_diagnostic_line_highlight TODO make lsp do this
      vim.g.everforest_disable_italic_comment = 1
      vim.cmd.colorscheme 'everforest'
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = { show_start = false, show_end = false },
    },
  },

  -- TODO make visual keybinds not show in normal
  {
    'numToStr/Comment.nvim',
    opts = {
      ignore = "^$",
      toggler = {
        line = "<leader>cc",
        block = "<leader>cb",
      },
      opleader = {
        line = "<leader>cz",
        block = "<leader>cx",
      },
      mappings = {
        basic = true,
        extra = false,
        extended = false,
      },
    },
  },

  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      { 'n',  [[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>]], mode = 'n', desc = 'Next search' },
      { 'N',  [[<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>]], mode = 'n', desc = 'Prev search' },
      { '*',  [[*<cmd>lua require('hlslens').start()<cr>]],                                             mode = 'n', desc = 'Search for word exclusive' },
      { '#',  [[#<cr><cmd>lua require('hlslens').start()<cr>]],                                         mode = 'n', desc = 'Search backwards for word exclusive' },
      { 'g*', [[g*<cr><cmd>lua require('hlslens').start()<cr>]],                                        mode = 'n', desc = 'Search for word inclusive' },
      { 'g#', [[g#<cr><cmd>lua require('hlslens').start()<cr>]],                                        mode = 'n', desc = 'Search backwards for word inclusive' },
    },
    opts = {
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
        else
          indicator = ''
        end

        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= '' then
            text = ('[%s %d/%d]'):format(indicator, idx, cnt)
          else
            text = ('[%d/%d]'):format(idx, cnt)
          end
          chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
        else
          text = ('[%s %d]'):format(indicator, idx)
          chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    },
  },

  {
    -- TODO v0.10 lewis6991/satellite.nvim
    'dstein64/nvim-scrollview',
    opts = {
      signs_on_startup = {},
    },
    config = function(_, opts)
      require 'scrollview'.setup(opts)
      vim.api.nvim_set_hl(0, 'ScrollView', { bg = "#475258" })
    end
  },

  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-w",
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-e",
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-b",
      },
      {
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-ge",
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = false },
      },
      jump = {
        autojump = true,
      },
      prompt = {
        win_config = {
          row = 1,
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
    },
  },

  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    config = true,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      messages = {
        view_search = false,
      },
      popupmenu = {
        backend = "cmp", -- command completion
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        signature = {
          opts = {
            size = {
              height = 1,
            },
            scrollbar = false,
          },
        },
      },
      presets = {
        command_palette = true, -- position the cmdline and popupmenu together
        inc_rename = true,
      },

    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          timeout = 2000,
          render = "wrapped-compact",
        }
      },
      "smjonas/inc-rename.nvim",
    },
  },

  {
    -- TODO just use quickfix list
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      position = "top",
    },
    keys = {
      { "<leader>qd", mode = "n", function() require("trouble").toggle("workspace_diagnostics") end, desc = "Open diagnositcs list" },
      { "<leader>qq", mode = "n", function() require("trouble").toggle("quickfix") end,              desc = "Open quickfix list" },
      { "<leader>ql", mode = "n", function() require("trouble").toggle("quickfix") end,              desc = "Open loclist list" },
      { "<leader>qr", mode = "n", function() require("trouble").toggle("lsp_references") end,        desc = "Open references list" },
    },
  },

  {
    "smjonas/inc-rename.nvim",
    keys = {
      { "<leader>rn", mode = "n", ":IncRename ", desc = "Rename with LSP" },
    },
    config = true,
  },

  {
    'echasnovski/mini.hipatterns',
    version = '*',
    opts = {
      highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'Fixme' },
        hack  = { pattern = '%f[%w]()HACK()%f[%W]', group = 'Hack' },
        todo  = { pattern = '%f[%w]()TODO()%f[%W]', group = 'Todo' },
        note  = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'Note' },
      },
    },
    config = function(self, opts)
      require('mini.hipatterns').setup(opts)

      -- TODO make these values come from the colourscheme vim.fn.{func}
      vim.api.nvim_set_hl(0, 'Fixme', { bg = "#543A48" })
      vim.api.nvim_set_hl(0, 'Hack', { bg = "#543A48" })
      vim.api.nvim_set_hl(0, 'Todo', { bg = "#543A48" })
      vim.api.nvim_set_hl(0, 'Note', { bg = "#3A515D" })
    end,
  },

  {
    "roobert/search-replace.nvim",
    opts = {},
    keys = {
      { "<leader>rr", mode = "n", function() require("search-replace.single-buffer").open() end,                      desc = 'Search and Replace' },
      { "<leader>rw", mode = "n", function() require("search-replace.single-buffer").cword() end,                     desc = 'Replace Current Word' },
      { "<leader>rr", mode = "v", function() require("search-replace.single-buffer").visual_charwise_selection() end, desc = 'Replace Visual Selection' },
      { "<leader>rb", mode = "n", function() require("search-replace.multi-buffer").open() end,                       desc = 'Search and Replace Multibuffer' },
    },
  },

  {
    'goolord/alpha-nvim',
    opts = {
      layout = {
        { type = "padding", val = 20 },
        {
          type = "text",
          val = {
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
          },
          opts = {
            position = "center",
            hl = "Type",
          },
        },
        { type = "padding", val = 20 },
        {
          type = "text",
          val = "TODO",
          opts = {
            position = "center",
            hl = "Number",
          },
        },
        { type = "button", val = "" }, -- performance reasons
      },
      opts = {
        margin = 5,
      },
    },
    config = function(_, opts)
      require('alpha').setup(opts)

      -- Cant hide winbar :(
      local showtabline, laststatus
      vim.api.nvim_create_augroup("Alpha", { clear = true })
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "AlphaReady",
        group = "Alpha",
        callback = function()
          laststatus = vim.o.laststatus
          showtabline = vim.o.showtabline

          vim.o.laststatus = 0
          vim.o.showtabline = 0
        end,
      })
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "AlphaClosed",
        group = "Alpha",
        callback = function()
          vim.o.laststatus = laststatus
          vim.o.showtabline = showtabline
        end,
      })
    end,
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    opts = {
      pattern = '*.cpp,*.h',
      floating = false,
      insert = true,
      disabled_modes = { 't', 'nt' },
    },
  },
}
