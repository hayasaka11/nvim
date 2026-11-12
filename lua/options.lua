local opt = vim.opt

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

opt.number = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.wrap = false
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.updatetime = 250
opt.timeoutlen = 500
opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
opt.clipboard = 'unnamedplus'
opt.undofile = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- ターミナルの背景色を活かす。色テーマを切り替えても維持する。
local function transparent_background()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
end
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('transparent-background', { clear = true }),
    callback = transparent_background,
})
transparent_background()
