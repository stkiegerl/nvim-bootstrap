return {
    {
        'mason-org/mason.nvim',
        config = function() require('mason').setup() end,
    },

    -- Install all formatters
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },

    {
        -- Configure formatters
        'stevearc/conform.nvim',
        dependencies = {
            'mason-org/mason.nvim',
            'WhoIsSethDaniel/mason-tool-installer',
        },
        config = function()
            require('mason-tool-installer').setup {
                ensure_installed = {
                    'stylua',
                    'isort',
                    'black',
                    'prettier',
                    'doctoc',
                    'beautysh',
                    'shfmt',
                    'sql-formatter',
                    'terraform',
                    'rustfmt',
                    'clang-format',
                    'prettierd',
                },
                run_on_start = false,
            }
            require('conform').setup {
                formatters_by_ft = {
                    lua = { 'stylua' },
                    -- Conform will run multiple formatters sequentially
                    python = { 'isort', 'black' },
                    -- You can customize some of the format options for the filetype (:help conform.format)
                    css = { 'prettier' },
                    html = { 'prettier' },
                    json = { 'prettier' },
                    yaml = { 'prettier' },
                    markdown = { 'prettier', 'doctoc' },
                    shell = { 'beautysh', 'shfmt' },
                    bash = { 'beautysh', 'shfmt' },
                    sh = { 'beautysh', 'shfmt' },
                    sql = { 'sql_formatter' },
                    terraform = { 'terraform_fmt' },
                    rust = { 'rustfmt' },
                    cpp = { 'clang-format' },
                    -- Conform will run the first available formatter
                    javascript = { 'prettierd', 'prettier', stop_after_first = true },
                    typescript = { 'prettierd', 'prettier', stop_after_first = true },
                },
                format_on_save = {
                    -- These options will be passed to conform.format()
                    timeout_ms = 1000,
                    lsp_format = 'fallback',
                },
            }
        end,
    },
}
