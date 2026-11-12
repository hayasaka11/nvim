vim.lsp.enable('lua-ls')
vim.lsp.enable('ts-ls')
vim.lsp.enable('pyright')

-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('mylsp', { clear = true }),
--     callback = function(ev)
--         local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
--         if client:supports_method('textDocument/completion') then
--             -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
--             -- client.server_capabilities.completionProvider.triggerCharacters = chars
--             vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
--         end
--     end
-- })
