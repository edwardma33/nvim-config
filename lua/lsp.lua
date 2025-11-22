require("nvim-treesitter.configs").setup({
  auto_install = true,
  sync_install = true,
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
  highlight = { enable = true },
})

-- Lsp
local cmp_cap = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config["ts_ls"] = {
  filetypes = {
    "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "templ", "astro"
  }
}

vim.lsp.config["lua_ls"] = {
  capabilities = cmp_cap,
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

vim.lsp.config["superhtml"] = {
  pattern = { "html", "templ" }
}

for _, server in ipairs({
  "gopls",
  "clangd",
  "pyright",
  "emmet_ls",
  "ts_ls",
  "superhtml",
  "html",
}) do
  vim.lsp.config[server] = {capabilities = cmp_cap}
end

vim.lsp.enable({
  "gopls",
  "lua_ls",
  "templ",
  "ts_ls",
  "superhtml",
  "emmet_language_server",
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



local cmp = require("cmp")

cmp.setup({
  completion = { autocomplete = { "TextChanged", "InsertEnter" } },

  mapping = {
    ["<Tab>"] = function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then cmp.select_prev_item() else fallback() end
    end,
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },

  sources = {
    { name = "nvim_lsp" },
  },
})

