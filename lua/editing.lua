local map = vim.keymap.set
local pairs_by_open = { ['('] = ')', ['['] = ']', ['{'] = '}' }

local function context()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    return line:sub(1, col), line:sub(col + 1, col + 1)
end

-- 単語や既存の文字の手前では、余分な閉じ括弧を挿入しない。
local function can_pair(right)
    return right == '' or right:match('[%s%)%]%},;:]') ~= nil
end
for open, close in pairs(pairs_by_open) do
    map('i', open, function()
        local _, right = context()
        return can_pair(right) and (open .. close .. '<Left>') or open
    end, { expr = true, desc = '括弧を自動で閉じる' })
    map('i', close, function()
        local _, right = context()
        return right == close and '<Right>' or close
    end, { expr = true, desc = '閉じ括弧をスキップ' })
end
for _, quote in ipairs({ "'", '"' }) do
    map('i', quote, function()
        local left, right = context()
        local escapes = left:match('(\\+)$') or ''
        if #escapes % 2 == 1 then return quote end
        if right == quote then return '<Right>' end
        if left:match('[%w_]$') or not can_pair(right) then return quote end
        return quote .. quote .. '<Left>'
    end, { expr = true, desc = 'クオートを自動で閉じる' })
end
map('i', '<BS>', function()
    local left, right = context()
    local last = left:sub(-1)
    if pairs_by_open[last] == right or ((last == "'" or last == '"') and last == right) then
        return '<BS><Del>'
    end
    return '<BS>'
end, { expr = true, desc = '空の括弧をまとめて削除' })

map('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then return '<C-n>' end
    local left = context()
    if left:match('^%s*$') then return '<Tab>' end
    if vim.bo.omnifunc ~= '' then return '<C-x><C-o>' end
    return '<C-n>'
end, { expr = true, desc = '補完・次の候補・インデント' })
map('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-d>'
end, { expr = true, desc = '前の候補・インデントを減らす' })
