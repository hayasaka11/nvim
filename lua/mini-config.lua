if not pcall(vim.cmd.packadd, 'mini.nvim') then
    return
end

require('mini.ai').setup()
local files = require('mini.files')
files.setup()
vim.keymap.set('n', '<leader>e', function()
    files.open()
end, { desc = 'ファイル一覧' })
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.statusline').setup()
require('mini-git-config')

require('mini.pick').setup()
vim.keymap.set('n', '<leader>sf', '<Cmd>Pick files<CR>', { desc = 'ファイルを検索' })
vim.keymap.set('n', '<leader>sg', '<Cmd>Pick grep_live<CR>', { desc = 'ファイルの内容を検索' })
vim.keymap.set('n', '<leader>sb', '<Cmd>Pick buffers<CR>', { desc = 'バッファを検索' })
