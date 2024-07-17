-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

local neotest_prefix = "<Leader>T"
---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              [neotest_prefix] = { desc = "󰗇 Tests" },
              [neotest_prefix .. "t"] = { function() require("neotest").run.run() end, desc = "Run test" },
              [neotest_prefix .. "d"] = {
                function() require("neotest").run.run { strategy = "dap" } end,
                desc = "Debug test",
              },
              [neotest_prefix .. "f"] = {
                function() require("neotest").run.run(vim.fn.expand "%") end,
                desc = "Run all tests in file",
              },
              [neotest_prefix .. "p"] = {
                function() require("neotest").run.run(vim.fn.getcwd()) end,
                desc = "Run all tests in project",
              },
              [neotest_prefix .. "<CR>"] = { function() require("neotest").summary.toggle() end, desc = "Test Summary" },
              [neotest_prefix .. "o"] = { function() require("neotest").output.open() end, desc = "Output hover" },
              [neotest_prefix .. "O"] = {
                function() require("neotest").output_panel.toggle() end,
                desc = "Output window",
              },
              ["]T"] = { function() require("neotest").jump.next() end, desc = "Next test" },
              ["[T"] = { function() require("neotest").jump.prev() end, desc = "previous test" },
            },
          },
        },
      },
      config = function()
        require("neotest").setup {
          adapters = {
            require "neotest-rspec" {
              rspec_cmd = function()
                return vim.tbl_flatten {
                  "docker",
                  "compose",
                  "exec",
                  "-i",
                  "-w",
                  "/app",
                  "-e",
                  "RAILS_ENV=test",
                  "app",
                  "bundle",
                  "exec",
                  "rspec",
                }
              end,

              transform_spec_path = function(path)
                local prefix = require("neotest-rspec").root(path)
                return string.sub(path, string.len(prefix) + 2, -1)
              end,

              results_path = "tmp/rspec.output",
            },
          },
        }
      end,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "ruby" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "solargraph" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "solargraph" })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = { "suketa/nvim-dap-ruby", config = true },
  },
}
-- -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
-- {
--   "L3MON4D3/LuaSnip",
--   config = function(plugin, opts)
--     require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
--     -- add more custom luasnip configuration such as filetype extend or custom snippets
--     local luasnip = require "luasnip"
--     luasnip.filetype_extend("javascript", { "javascriptreact" })
--   end,
-- },
--
-- {
--   "windwp/nvim-autopairs",
--   config = function(plugin, opts)
--     require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
--     -- add more custom autopairs configuration such as custom rules
--     local npairs = require "nvim-autopairs"
--     local Rule = require "nvim-autopairs.rule"
--     local cond = require "nvim-autopairs.conds"
--     npairs.add_rules(
--       {
--         Rule("$", "$", { "tex", "latex" })
--           -- don't add a pair if the next character is %
--           :with_pair(cond.not_after_regex "%%")
--           -- don't add a pair if  the previous character is xxx
--           :with_pair(
--             cond.not_before_regex("xxx", 3)
--           )
--           -- don't move right when repeat character
--           :with_move(cond.none())
--           -- don't delete if the next character is xx
--           :with_del(cond.not_after_regex "xx")
--           -- disable adding a newline when you press <cr>
--           :with_cr(cond.none()),
--       },
--       -- disable for .vim files, but it work for another filetypes
--       Rule("a", "a", "-vim")
--     )
--   end,
-- },
