-- Begin plug-in setup
vim.cmd([[filetype off]])

-- embear/vim-localvimrc
vim.g.localvimrc_name = {'_vimrc_local.vim'}
vim.g.localvimrc_persistence_file = vim.fn.stdpath('state') .. '/localvimrc_persistent'
vim.g.localvimrc_whitelist = {
  '/export/rkennedy/src',
  '/data/rkennedy/src',
  '/home/rkennedy/src/catreader',
  '/home/rkennedy/work/src',
  '/home/rkennedy/dotfiles',
}
vim.g.localvimrc_persistent = 2

-- End plug-in setup

vim.cmd.syntax('on')
vim.o.foldcolumn = '2' -- left columns for code-folding indicators
vim.o.hlsearch = true -- highlight all search results

-- Wait forever for compound commands
vim.o.timeout = false

-- Options to better see where we are
vim.o.number = true
vim.o.relativenumber = true
vim.o.colorcolumn = 80
vim.api.nvim_create_autocmd('FileType', {
  desc = "Don't show column highlight in the quickfix window",
  pattern = 'qf',
  group = vim.api.nvim_create_augroup('quickfix-colors', { clear = true }),
  callback = function (opts)
    vim.bo.colorcolon = ""
  end,
})
vim.o.cursorline = true
vim.o.showcmd = true

vim.opt.formatoptions:remove (
  'o' .. -- Don't continue comments after pressing O or o.
  ''
)
vim.opt.formatoptions:append (
  'r' .. -- automatically insert comment-continuation char
  'j' .. -- Remove comment leader when joining lines
  'n' .. -- Use hanging indents in lists.
  ''
)
vim.o.joinspaces = false -- no extra space between sentences joined from multiple lines

vim.opt.cinoptions:append {
  'l1', -- align code under case label, not brace
  't0', -- don't indent function return type
  '(0', -- align with unclosed parenthesis ...
  'W4', -- ... unless it's at the end of a line
  'g0', -- align C++ visibility with the enclosing block
  ':0', -- align case labels with enclosing switch block
}

vim.o.undofile = true

-- Disable mouse support
vim.o.mouse = ''

-- Open new windows below (:new) or right (:vnew) of the current window
vim.o.splitbelow = true
vim.o.splitright = true

-- markdown
vim.g.markdown_recommended_style = 1
vim.g.markdown_fenced_languages = {
  "c++=cpp",
  'python',
  'bash=sh',
}
vim.g.markdown_syntax_conceal = 1

vim.cmd([[filetype plugin indent on]])

vim.cmd([[command Wz :write | :suspend]])

vim.cmd([[source $DOTFILES/vim-statusline.vim]])

-- Display highlighting settings under cursor position
vim.keymap.set('', '<F10>', function()
  local id = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), true)
  local trans = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), false)
  print(string.format('hi<%s> trans<%s> lo<%s>',
    vim.fn.synIDattr(id, 'name'),
    vim.fn.synIDattr(trans, 'name'),
    vim.fn.synIDattr(vim.fn.synIDtrans(id), 'name')))
end)

-- WiX files are XML
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  desc = 'Treat WiX files as XML',
  pattern = '*.wxs',
  group = vim.api.nvim_create_augroup('wix-ft', { clear = true }),
  callback = function(opts)
    vim.bo.filetype = 'xml'
  end,
})

vim.opt.tags:prepend {
  '.git/tags;',
}

config = require('lspconfig')

config.gopls.setup{
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Format Go code upon saving',
  pattern = "*.go",
  group = vim.api.nvim_create_augroup('go-fmt', {clear = true}),
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {'source.organizeImports'}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

-- vim: set et sw=2:
