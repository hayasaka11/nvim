local group = vim.api.nvim_create_augroup('editor-behavior', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'json', 'jsonc', 'yaml', 'html', 'css' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'markdown',
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.formatoptions:append('ro')
        vim.opt_local.comments:append('b:- [ ]')
        for _, marker in ipairs({ '-', '*', '+' }) do
            vim.opt_local.comments:remove('fb:' .. marker)
            vim.opt_local.comments:append('b:' .. marker)
        end
    end,
})
