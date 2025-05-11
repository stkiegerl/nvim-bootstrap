return {
    {
        'stevearc/conform.nvim',
        dependencies = { 'mason-org/mason.nvim', opts = {} },
        opts = {
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'black' },
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
                cpp = { 'clang-format' },
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
                typescript = { 'prettierd', 'prettier', stop_after_first = true },
            },
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = 'fallback',
            },
        },
        keys = {
            { '<leader>cf', function() require('conform').format() end, desc = 'Format buffer/selection' },
        },
        -- Install all formatters with Mason
        config = function(_, opts)
            -- Derive list of package names
            local registry = require 'mason-registry'

            -- build a deduped list of formatter names:
            local seen = {}
            local formatters = {}
            vim.iter(pairs(opts.formatters_by_ft)):each(function(_, tools)
                vim.iter(ipairs(tools)):each(function(_, name)
                    if type(name) == 'string' and not seen[name] then
                        seen[name] = true
                        table.insert(formatters, name)
                    end
                end)
            end)

            -- Install each formatter exactly once
            for _, name in ipairs(formatters) do
                if registry.has_package(name) then
                    local pkg = registry.get_package(name)
                    if not pkg:is_installed() then vim.schedule(function() pkg:install() end) end
                end
            end

            -- Setup Conform with the same opts
            require('conform').setup(opts)
        end,
    },
}
