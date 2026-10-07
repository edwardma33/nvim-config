local M = {}

local root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }

function M.is_spring_config(path)
  local name = vim.fs.basename(path)
  local is_spring_name = name:match("^application") ~= nil or name:match("^bootstrap") ~= nil
  local is_supported_extension = name:match("%.properties$") ~= nil
    or name:match("%.yml$") ~= nil
    or name:match("%.yaml$") ~= nil
  return is_spring_name and is_supported_extension
end

function M.root_dir(path)
  return vim.fs.root(path, root_markers)
    or (vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path))
end

local function documentation_text(item)
  local documentation = item.documentation
  if type(documentation) == "table" then documentation = documentation.value end
  if type(documentation) ~= "string" or documentation == "" then
    documentation = "No description was supplied by Spring Boot Tools."
  end
  return documentation
end

local function property_lines(item)
  local lines = { item.label, "" }
  if item.detail and item.detail ~= "" then
    table.insert(lines, "Type: `" .. item.detail .. "`")
    table.insert(lines, "")
  end
  vim.list_extend(lines, vim.split(documentation_text(item), "\n", { plain = true }))
  return lines
end

local function resolve_item(client, bufnr, item, callback)
  if item.documentation then
    callback(item)
    return
  end

  client:request("completionItem/resolve", item, function(_, resolved)
    vim.schedule(function() callback(resolved or item) end)
  end, bufnr)
end

local function start_picker(client, bufnr, items)
  local preview_generation = 0

  require("mini.pick").start({
    source = {
      name = "Spring Config Properties",
      items = items,
      show = function(buf_id, shown_items, query)
        local lines, matches = MiniPick.default_show(buf_id, shown_items, query)
        for i, item in ipairs(shown_items) do
          lines[i] = item.label .. (item.detail and "  — " .. item.detail or "")
        end
        return lines, matches
      end,
      preview = function(buf_id, item)
        preview_generation = preview_generation + 1
        local generation = preview_generation
        vim.bo[buf_id].filetype = "markdown"
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { item.label, "", "Loading documentation…" })
        resolve_item(client, bufnr, item, function(resolved)
          if generation == preview_generation and vim.api.nvim_buf_is_valid(buf_id) then
            vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, property_lines(resolved))
          end
        end)
      end,
      choose = function(item)
        resolve_item(client, bufnr, item, function(resolved)
          vim.lsp.util.open_floating_preview(property_lines(resolved), "markdown", {
            border = "rounded",
            title = " Spring Boot property ",
          })
        end)
        return true
      end,
    },
  })
end

local function request_properties(client, bufnr, root)
  local scratch = vim.api.nvim_create_buf(false, true)
  vim.b[scratch].spring_config_search = true
  vim.api.nvim_buf_set_name(scratch, root .. "/application-nvim-search.properties")
  vim.bo[scratch].filetype = "jproperties"
  vim.lsp.buf_attach_client(scratch, client.id)

  local params = {
    textDocument = { uri = vim.uri_from_bufnr(scratch) },
    position = { line = 0, character = 0 },
    context = { triggerKind = vim.lsp.protocol.CompletionTriggerKind.Invoked },
  }
  local attempts = 0

  local function request()
    if client:is_stopped() or not vim.api.nvim_buf_is_valid(scratch) then return end
    client:request("textDocument/completion", params, function(_, result)
      local items = result and (result.items or result) or {}
      if #items > 0 then
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(scratch) then vim.api.nvim_buf_delete(scratch, { force = true }) end
          table.sort(items, function(a, b) return a.label < b.label end)
          start_picker(client, bufnr, items)
        end)
        return
      end

      attempts = attempts + 1
      if attempts < 20 then
        vim.defer_fn(request, 500)
      else
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(scratch) then vim.api.nvim_buf_delete(scratch, { force = true }) end
          vim.notify("Spring Boot metadata is not available for this project.", vim.log.levels.WARN)
        end)
      end
    end, scratch)
  end

  vim.defer_fn(request, 100)
end

function M.search()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  local root = M.root_dir(path ~= "" and path or vim.fn.getcwd())
  local attempts = 0

  vim.notify("Loading project Spring Boot metadata…", vim.log.levels.INFO)

  local function wait_for_client()
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "spring-boot" })[1]
    if not client then
      for _, candidate in ipairs(vim.lsp.get_clients({ name = "spring-boot" })) do
        if candidate.root_dir == root then
          client = candidate
          break
        end
      end
    end

    if client and client.initialized then
      request_properties(client, bufnr, root)
      return
    end

    attempts = attempts + 1
    if attempts < 120 then
      vim.defer_fn(wait_for_client, 250)
    else
      vim.notify("Spring Boot Tools did not start for this project.", vim.log.levels.WARN)
    end
  end

  wait_for_client()
end

return M
