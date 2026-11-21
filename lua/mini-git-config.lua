require('mini.git').setup()
local diff = require('mini.diff')
local map = vim.keymap.set

diff.setup({
    view = { style = 'sign', signs = { add = '▎', change = '▎', delete = '▁' } },
    mappings = { apply = '', reset = '', textobject = '', goto_first = '', goto_prev = '', goto_next = '', goto_last = '' },
})

local function colors()
    for kind, color in pairs({ Add = '#73c991', Change = '#e2c08d', Delete = '#f14c4c' }) do
        vim.api.nvim_set_hl(0, 'MiniDiffSign' .. kind, { fg = color })
    end
end
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('git-sign-colors', { clear = true }),
    callback = colors,
})
colors()

for key, direction in pairs({ [']c'] = 'next', ['[c'] = 'prev' }) do
    map('n', key, function()
        if vim.wo.diff or not diff.get_buf_data() then
            vim.cmd.normal({ vim.v.count1 .. key, bang = true })
        else
            diff.goto_hunk(direction, { n_times = vim.v.count1 })
        end
    end, { desc = 'Git変更箇所へ移動' })
end

local function close_diff()
    local origin = vim.t.git_diff_origin
    if not origin then return false end
    vim.cmd.tabclose()
    if vim.api.nvim_win_is_valid(origin) then
        vim.api.nvim_set_current_win(origin)
    end
    return true
end

local function toggle_diff(use_head)
    if close_diff() then return end
    local data = diff.get_buf_data()
    local reference = data and data.ref_text
    local label = 'index'
    if use_head then
        local path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0))
        if path then
            local result = vim.system({ 'git', 'show', 'HEAD:./' .. vim.fs.basename(path) }, {
                cwd = vim.fs.dirname(path),
            }):wait(2000)
            reference = result.code == 0 and result.stdout or nil
        else
            reference = nil
        end
        label = 'HEAD'
    end
    if reference == nil then
        vim.notify(label .. ' の比較対象がありません。', vim.log.levels.INFO)
        return
    end

    local origin = vim.api.nvim_get_current_win()
    local filetype = vim.bo.filetype
    local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
    vim.cmd('tab split')
    vim.t.git_diff_origin = origin
    local working = vim.api.nvim_get_current_win()

    local snapshot = vim.api.nvim_create_buf(false, true)
    vim.b[snapshot].minidiff_disable = true
    vim.bo[snapshot].bufhidden = 'wipe'
    vim.api.nvim_buf_set_name(snapshot, ('mini-diff://%d/%s/%s'):format(snapshot, label, name))
    local lines = vim.split(reference:gsub('\n$', ''), '\n', { plain = true })
    vim.api.nvim_buf_set_lines(snapshot, 0, -1, false, lines)
    vim.bo[snapshot].filetype = filetype
    vim.bo[snapshot].modifiable = false
    vim.cmd('leftabove vertical sbuffer ' .. snapshot)
    vim.cmd.diffthis()
    vim.api.nvim_set_current_win(working)
    vim.cmd.diffthis()
end

for _, key in ipairs({ '<leader>gp', '<leader>gi', '<leader>gw' }) do
    map('n', key, function() diff.toggle_overlay() end, { desc = '行内Git差分を切り替え' })
end
map('n', '<leader>gd', function() toggle_diff(false) end, { desc = 'Git左右比較を開く・閉じる' })
map('n', '<leader>gD', function() toggle_diff(true) end, { desc = 'HEAD左右比較を開く・閉じる' })
map('n', '<leader>gq', close_diff, { desc = 'Git比較を閉じて編集に戻る' })
