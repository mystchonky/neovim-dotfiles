return {
  setup = function(undo_dir)
    local encoding = "utf-8"
    local opts = {
      autoindent = true,
      background = "dark",
      backup = false,
      cmdheight = 1,
      completeopt = "menuone,noselect",
      cursorline = true,
      encoding = encoding,
      errorbells = false,
      expandtab = true,
      fileencoding = encoding,
      fileformats = "unix,dos,mac",
      foldcolumn = "1",
      hidden = true,
      history = 1000,
      hlsearch = false,
      ignorecase = true,
      incsearch = true,
      laststatus = 3,
      lazyredraw = true,
      magic = true,
      mat = 2,
      mouse = "nvi",
      number = true,
      relativenumber = true,
      ruler = false,
      scrolloff = 7,
      shiftwidth = 2,
      shortmess = vim.o.shortmess .. "W",
      showmatch = true,
      showmode = false,
      smartindent = true,
      smarttab = true,
      swapfile = false,
      tabstop = 2,
      termguicolors = true,
      timeoutlen = 500,
      undodir = undo_dir,
      undofile = true,
      updatetime = 100,
      visualbell = false,
      wrap = false,
      writebackup = false,
      splitright = true,
      splitbelow = true,
      pumheight = 10,
    }

    for opt, val in pairs(opts) do
      vim.o[opt] = val
    end

    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "highlight yanked region temporarily",
      pattern = "*",
      callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "clean up trailing whitespace before saving",
      pattern = "*",
      callback = function()
        local save = vim.fn.winsaveview()
        -- See: https://github.com/cappyzawa/trim.nvim/blob/master/lua/trim/config.lua
        local patterns = {
          [[%s/\s\+$//e]],
          [[%s/\($\n\s*\)\+\%$//]],
          [[%s/\%^\n\+//]],
        }

        for _, pattern in pairs(patterns) do
          vim.api.nvim_exec(string.format("silent! %s", pattern), false)
        end

        vim.fn.winrestview(save)
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      desc = "don't auto commenting new lines",
      pattern = "*",
      command = [[set fo-=c fo-=r fo-=o ]],
    })

    local leader = " "

    vim.g.mapleader = leader
    vim.g.maplocalleader = leader
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      desc = "set filetype for qml",
      pattern = "*.qml",
      command = "set ft=qml",
    })
  end,
}