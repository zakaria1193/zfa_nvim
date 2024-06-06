local M = {}

function M.print_lsp_server_capabilities()
  local client_id = vim.lsp.get_clients()
  if next(client_id) == nil then
    print("No active LSP clients")
    return
  end
  local client = client_id[1]
  if client ~= nil then
    local cap = vim.inspect(client.server_capabilities)
    -- Print cap to buffer (it has newline)
    vim.api.nvim_command("new")
    for line in cap:gmatch("[^\r\n]+") do
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { line })
    end
  end
end

function M.toggle_inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end

return M
