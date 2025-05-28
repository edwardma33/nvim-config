return {
  {
    "preservim/nerdtree",
    dependencies = {
      "ryanoasis/vim-devicons"
    },
    keys = {
      {"<leader>n", "<cmd>NERDTreeToggle<cr>", desc = "Toggle NERDTree", mode = "n"},
    },
 },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      {"<leader>gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition", mode = "n"},
      {"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files", mode = "n"}
    },
    config = function ()
      require("telescope").setup({})
    end
  },
}
