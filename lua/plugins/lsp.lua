return {
  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      require('config.lsp-config')
    end,
  },
}
