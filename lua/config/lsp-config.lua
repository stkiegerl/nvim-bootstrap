local servers = {
    bashls         = {},
    clangd         = {},
    yamlls         = {},
    jsonls         = {},
    html           = {},
    cssls          = {},
    tailwindcss    = {},
    dockerls       = {},
    sqlls          = {},
    terraformls    = {},
    ts_ls          = {},
    ruff           = {},
    texlab         = {},
    markdown_oxide = {},
    pylsp          = {
        settings = {
            pylsp = {
                plugins = {
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    mccabe = { enabled = false },
                    pylsp_mypy = { enabled = false },
                    pylsp_black = { enabled = false },
                    pylsp_isort = { enabled = false },
                },
            },
        },
    },
    lua_ls         = {
        settings = {
            Lua = {
                diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
                workspace   = {
                    library         = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry   = { enable = false },
            },
        },
    },
}

-- Auto-install and enable the LSPs with Mason
local ensure_installed = vim.tbl_keys(servers)
require('mason-lspconfig').setup {
    ensure_installed = ensure_installed,
}

-- Enable each LSP and apply clustom configs
for name, cfg in pairs(servers) do
    if next(cfg) then
        vim.lsp.config(name, cfg)
    end
end

-- Enable autocompletion (Optional)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method 'textDocument/completion' then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- Show diagnostic messages (errors & warnings) inline
vim.diagnostic.config { virtual_text = true }
