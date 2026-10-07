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
    "java",
    "swift"
  },
  highlight = { enable = true },
})

-- Lsp
local cmp_cap = require("cmp_nvim_lsp").default_capabilities()
local spring_config = require("spring-config")
local spring_tools_dir = vim.fn.stdpath("data") .. "/mason/packages/vscode-spring-boot-tools/extension"
local spring_boot_jar = vim.fn.glob(
  spring_tools_dir .. "/language-server/spring-boot-language-server-*-exec.jar",
  false,
  true
)[1]

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
  capabilities = cmp_cap,
  pattern = { "html", "templ" },
}

vim.lsp.config["marksman"] = {
  capabilities = cmp_cap,
  pattern = { "markdown", "md" }
}

local sqls_database_url = vim.env.NVIM_SQLS_DATABASE_URL

vim.lsp.config["sqls"] = {
  capabilities = cmp_cap,
  filetypes = { "sql" },
  settings = {
    sqls = sqls_database_url and {
      connections = {
        {
          name = "local",
          driver = "postgresql",
          dataSourceName = sqls_database_url,
        },
      },
      defaultConnection = "local",
    } or {},
  }
}

vim.lsp.config("bashls", {
  capabilities = cmp_cap,
  filetypes = {"sh", "bash"},
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off"
      }
    }
  }
})

vim.lsp.config("sourcekit", {
  cmd = { "xcrun", "sourcekit-lsp" },
  filetypes = { "swift", "objc", "objcpp" },
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(path)

    while dir do
      if vim.uv.fs_stat(dir .. "/buildServer.json")
        or vim.uv.fs_stat(dir .. "/Package.swift")
      then
        on_dir(dir)
        return dir
      end

      for name, type in vim.fs.dir(dir) do
        if type == "directory" and (name:match("%.xcworkspace$") or name:match("%.xcodeproj$")) then
          on_dir(dir)
          return dir
        end
      end

      if vim.uv.fs_stat(dir .. "/.git") then
        on_dir(dir)
        return dir
      end

      local parent = vim.fs.dirname(dir)
      if parent == dir then
        return nil
      end
      dir = parent
    end
  end,
  capabilities = cmp_cap,
})

-- spring-boot.nvim bridges Spring Boot Tools and jdtls, letting the existing
-- Spring Boot Tools package supply project-aware metadata to nvim-cmp and hover.
local has_spring_boot, spring_boot = pcall(require, "spring_boot")
if has_spring_boot and spring_boot_jar then
  local spring_boot_opts = spring_boot.setup({
    ls_path = spring_boot_jar,
    autocmd = false,
    server = {
      capabilities = cmp_cap,
      init_options = { enableJdtClasspath = true },
      on_attach = function(_, bufnr)
        -- cmp-nvim-lsp normally discovers clients only on InsertEnter. Spring
        -- starts asynchronously, so register it when it attaches as well.
        require("cmp_nvim_lsp")._on_insert_enter()

        -- Metadata arrives shortly after the server attaches. An early empty
        -- request is not retried by nvim-cmp, so refresh it for a few seconds
        -- when the user is already typing in a Spring config buffer.
        local attempts = 0
        local function refresh_completion()
          if not vim.api.nvim_buf_is_valid(bufnr)
            or vim.api.nvim_get_current_buf() ~= bufnr
            or vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i"
          then
            return
          end

          local cursor = vim.api.nvim_win_get_cursor(0)
          local line = vim.api.nvim_get_current_line():sub(1, cursor[2])
          if line:match("%S") then
            local cmp = require("cmp")
            if #cmp.get_entries() > 0 then return end
            local fetching = false
            for _, source in ipairs(cmp.get_registered_sources()) do
              fetching = fetching or (source.name == "nvim_lsp" and source.status == 2)
            end
            if not fetching then cmp.complete() end
          end

          attempts = attempts + 1
          if attempts < 20 then vim.defer_fn(refresh_completion, 500) end
        end

        vim.defer_fn(refresh_completion, 500)
      end,
    },
  })
  vim.lsp.config("jdtls", {
    init_options = {
      bundles = spring_boot.java_extensions(spring_tools_dir .. "/jars"),
    },
  })

  local function start_spring_boot(bufnr)
    if vim.b[bufnr].spring_config_search then return end
    local path = vim.api.nvim_buf_get_name(bufnr)
    local is_java = vim.bo[bufnr].filetype == "java"
    if not is_java and not spring_config.is_spring_config(path) then return end

    local root = spring_config.root_dir(path)
    local jdtls_config = vim.deepcopy(vim.lsp.config.jdtls)
    jdtls_config.root_dir = root

    -- Spring Boot Tools asks jdtls for the project classpath during startup.
    -- Starting it first also makes completion work when a config file is the
    -- first file opened in a project.
    local jdtls_id = vim.lsp.start(jdtls_config, {
      bufnr = bufnr,
      attach = is_java,
      silent = true,
    })
    if not jdtls_id then return end

    local attempts = 0
    local function start_when_jdtls_is_ready()
      local client = vim.lsp.get_client_by_id(jdtls_id)
      if client and client.initialized then
        local opts = vim.deepcopy(spring_boot_opts)
        opts.server.root_dir = root
        local config = require("spring_boot.launch").update_ls_config(opts)
        vim.lsp.start(config, { bufnr = bufnr })
        return
      end

      attempts = attempts + 1
      if attempts < 300 and vim.api.nvim_buf_is_valid(bufnr) then
        vim.defer_fn(start_when_jdtls_is_ready, 100)
      end
    end

    start_when_jdtls_is_ready()
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("spring_boot_ls", { clear = true }),
    pattern = { "java", "yaml", "jproperties" },
    callback = function(args) start_spring_boot(args.buf) end,
    desc = "Start Spring Boot Tools after the Java project is ready",
  })
end

for _, server in ipairs({
  "rust_analyzer",
  "gopls",
  "clangd",
  "pyright",
  "emmet_ls",
  "ts_ls",
  "superhtml",
  "html",
  "cssls"
}) do
  vim.lsp.config[server] = {capabilities = cmp_cap}
end

vim.lsp.enable({
  "sourcekit",
  "cssls",
  "bashls",
  "rust_analyzer",
  "marksman",
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
  "docker_compose_langserver",
  "sqls"
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
