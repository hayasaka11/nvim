vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    virtual_text = { spacing = 2, source = 'if_many' },
    float = { border = 'rounded', source = true },
    update_in_insert = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-setup', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end
        local function map(key, action, description)
            vim.keymap.set('n', key, action, { buffer = event.buf, desc = description })
        end
        map('gd', vim.lsp.buf.definition, '定義へ移動')
        map('gr', vim.lsp.buf.references, '参照を表示')
        map('<leader>rn', vim.lsp.buf.rename, '名前を変更')
        map('<leader>ca', vim.lsp.buf.code_action, 'コードアクション')
        map('<leader>d', vim.diagnostic.open_float, '診断の詳細')
        if client:supports_method('textDocument/formatting') then
            map('<leader>f', function() vim.lsp.buf.format({ bufnr = event.buf }) end, 'フォーマット')
        end
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        end
    end,
})

-- インストール済みのサーバーだけ有効化する。
for name, command in pairs({
    ['lua-ls'] = 'lua-language-server',
    ['ts-ls'] = 'typescript-language-server',
    pyright = 'pyright-langserver',
}) do
    if vim.fn.executable(command) == 1 then vim.lsp.enable(name) end
end
