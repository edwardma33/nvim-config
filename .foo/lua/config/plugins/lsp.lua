return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require("nvim-treesitter.configs").setup{
        ensure_installed = {
          "html",
          "javascript",
          "typescript",
          "tsx",
          "css",
          "json",
          "lua",
          "go",
          "python",
          "java"
        },
        highlight = {
          enable = true
        }
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
  },
{
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")
    local home = os.getenv("HOME")
    local workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    local config = {
      cmd = { "jdtls", "-data", workspace },
      root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git" }),
    }

    jdtls.start_or_attach(config)
  end
},
  {
    "williamboman/mason.nvim",
    dependencies = { "folke/neodev.nvim" },
    config = function()
      require("mason").setup()
      require("neodev").setup()

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- Lua config
      vim.lsp.config["lua_ls"] = {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = {"vim"} },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            }
          }
        }
      }

      -- typescript config
      vim.lsp.config["ts_ls"] = {
        filetypes = {
          "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "templ", "astro"
        }
      }

      -- html and tailwindcss config

      vim.lsp.config["html"] = {
        capabilities = capabilities
      }

      vim.lsp.config["tailwindcss"] = {
        capabilities = capabilities,
        filetypes = {
          "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "templ", "astro"
        }
      }

      -- java config
      vim.lsp.config["jdtls"] = {
        cmd = { "jdtls" },
        root_dir = vim.fs.root(0, { "mvnw", "gradlew", ".git" }),
        -- Each project gets its own workspace folder
        on_new_config = function(config, root_dir)
          config.cmd = {
            "jdtls",
            "-data",
            vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
          }
        end,
      }

      for _, server in ipairs({
        "gopls",
        "clangd",
        "pyright",
        "emmet_ls",
        "ts_ls"
      }) do
        vim.lsp.config[server] = {capabilities = capabilities}
      end

      vim.lsp.enable({
        "gopls",
        "lua_ls",
        "templ",
        "ts_ls",
        "html",
        "emmet_ls",
        "htmx",
        "tailwindcss",
        "pyright",
        "jdtls",
        "clangd",
        "yamlls",
        "dockerls",
        "docker_compose_language_service",
        "vscode_spring_boot_tools",
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        --;ldkfjasdfl;kjsdflksjadfjsd

          mapping = {

    -- ... Your other mappings ...
   ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            if luasnip.expandable() then
                luasnip.expand()
            else
               cmp.confirm({
                    select = true,
                })
            end
        else
            fallback()
        end
    end),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- ... Your other mappings ...
  },

        --fa;lsdjfalsdjflsjfds;fljsdk
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" }
        })
      })
    end,
  },

{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup()

    -- Optional: add integration with nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done({
        map_char = { tex = "" }, -- optional if you're not using TeX
      })
    )
  end,
},

-- With Lazy.nvim
{
  "preservim/vim-markdown",
  config = function ()
    vim_markdown_folding_disabled = 1
  end
},
{
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
},
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  }
}
