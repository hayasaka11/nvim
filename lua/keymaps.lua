local map = vim.keymap.set

map('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = '検索ハイライトを消す' })
map('n', '<leader>w', '<Cmd>write<CR>', { desc = '保存' })
map('n', '<leader>e', '<Cmd>Explore<CR>', { desc = 'ファイル一覧' })
map('n', '<leader>q', '<Cmd>copen<CR>', { desc = 'Quickfixを開く' })
map('n', '<leader>bn', '<Cmd>bnext<CR>', { desc = '次のバッファ' })
map('n', '<leader>bp', '<Cmd>bprevious<CR>', { desc = '前のバッファ' })
for key, direction in pairs({ h = 'h', j = 'j', k = 'k', l = 'l' }) do
    map('n', '<C-' .. key .. '>', '<C-w>' .. direction, { desc = 'ウィンドウ移動' })
end
map('v', '<', '<gv', { desc = '選択を保ってインデントを減らす' })
map('v', '>', '>gv', { desc = '選択を保ってインデントを増やす' })
map('n', 'j', function() return vim.v.count == 0 and 'gj' or 'j' end, { expr = true })
map('n', 'k', function() return vim.v.count == 0 and 'gk' or 'k' end, { expr = true })
