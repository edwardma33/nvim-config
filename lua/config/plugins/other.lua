return {
  {
  'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        shortcut_type = "number",
        week_header = {
          enable = true
        }
      }
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
}
}
