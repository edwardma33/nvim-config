return {
  {
    "preservim/nerdtree",
    dependencies = {
      "ryanoasis/vim-devicons"
    },
    keys = {
      {"<leader>n", "<cmd>NERDTreeToggle<cr>", desc = "Toggle NERDTree", mode = "n"},
    },
    config = function()
      vim.g.NERDTreeWinPos = "right"
    end
 },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      {"<leader>gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition", mode = "n"},
      {"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files", mode = "n"},
      {"<leader>D", "<cmd>Telescope diagnostics<cr>", desc = "Show errors", mode = "n"}
    },
    lazy = false,
    config = function ()
      require("telescope").setup({
        defaults = {
          wrap_results = true,
        }
      })
    end
  },
  {
    "tiagofumo/vim-nerdtree-syntax-highlight"
  }
}
