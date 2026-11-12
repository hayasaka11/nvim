vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.opt.clipboard = 'unnamed'

-- インデント幅2にする
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('filetype-indent', { clear = true } ),
    pattern = {'typescript', 'typescriptreact'},
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end
})

-- markdown 箇条書き自動挿入
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('markdown-autoformat', { clear = true } ),
    pattern = {'markdown'},
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.formatoptions:append('ro')
        vim.opt_local.comments:append('b:- [ ]')
        vim.opt_local.comments:remove('fb:-')
        vim.opt_local.comments:append('b:-')
        vim.opt_local.comments:remove('fb:*')
        vim.opt_local.comments:append('b:*')
        vim.opt_local.comments:remove('fb:+')
        vim.opt_local.comments:append('b:+')
    end
})


-- 括弧などを自動で閉じる設定
local brackets = {
    ['('] = ')',
    ['{'] = '}',
    ['['] = ']',
}
local quotes = {
    "'", '"'
}
for open, close in pairs(brackets) do
    vim.keymap.set('i', open, open .. close .. '<Left>', { desc = '括弧を自動で閉じる' })
end

-- 補完のtabの動作を設定
vim.keymap.set('i', '<Tab>', function()
    -- カーソルの左側が空白ならインデント追加
    local function get_cursor_left()
       local _, col = unpack(vim.api.nvim_win_get_cursor(0))
       local line = vim.api.nvim_get_current_line()
       return line:sub(1, col)
    end
    if get_cursor_left():match('^%s*$') then
        return '<Tab>'
    elseif vim.fn.pumvisible() ~= 0 then
        return '<C-n>'
    else
        return '<C-x><C-o>'
    end
end, { expr = true, desc = 'tabで次の候補に' })

-- 補完のtab動作を設定
-- なんかおかしい
vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() ~= 0 then
        return '<C-p>'
    else
        return '<C-d>'
    end
end, { expr = true, desc = 'tab+shiftで候補を戻る' })


--- カーソルが置かれている文字を取得する
local function get_current_cursor_char()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    return line:sub(col + 1, col + 1)
end
for _, close in pairs(brackets) do
    vim.keymap.set('i', close, function()
        if get_current_cursor_char() == close then
            return '<Right>'
        else
            return close
        end
    end, { expr = true })
end
for _, symbol in ipairs(quotes) do
    vim.keymap.set('i', symbol, function()
        if get_current_cursor_char() == symbol then
            return '<Right>'
        else
            return symbol .. symbol .. '<Left>'
        end
    end, { expr = true, desc = 'クオートを自動で閉じる' })
end
