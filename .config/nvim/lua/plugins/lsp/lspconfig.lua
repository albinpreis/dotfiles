return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        -- ============================================================
        -- LSP Keymaps
        -- ============================================================
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                -- Get the client's position encoding
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                local encoding = client and client.offset_encoding or "utf-16"

                opts.desc = "Show LSP references"
                vim.keymap.set("n", "gR", function()
                    vim.lsp.buf.references(nil, { position_encoding = encoding })
                end, opts)

                opts.desc = "Go to declaration"
                vim.keymap.set("n", "gD", function()
                    vim.lsp.buf.declaration({ position_encoding = encoding })
                end, opts)

                opts.desc = "Show LSP definitions"
                vim.keymap.set("n", "gd", function()
                    vim.lsp.buf.definition({ position_encoding = encoding })
                end, opts)

                opts.desc = "Show LSP implementations"
                vim.keymap.set("n", "gi", function()
                    vim.lsp.buf.implementation({ position_encoding = encoding })
                end, opts)

                opts.desc = "Show LSP type definitions"
                vim.keymap.set("n", "gt", function()
                    vim.lsp.buf.type_definition({ position_encoding = encoding })
                end, opts)

                opts.desc = "See available code actions"
                vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Show documentation for symbol under cursor"
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
            end,
        })

        -- ============================================================
        -- Diagnostic signs and config
        -- ============================================================
        local signs = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
            [vim.diagnostic.severity.INFO]  = " ",
        }

        vim.diagnostic.config({
            signs = { text = signs },
            virtual_text = true,
            underline = true,
            update_in_insert = false,
        })

        -- ============================================================
        -- LSP Capabilities (for completion and snippet support)
        -- ============================================================
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Apply to all servers by default
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- ============================================================
        -- LSP Servers
        -- ============================================================

        -- Lua
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
        vim.lsp.enable("lua_ls")

        -- Emmet (HTML, CSS, JSX)
        vim.lsp.config("emmet_language_server", {
            filetypes = {
                "css", "eruby", "html", "javascript", "javascriptreact",
                "less", "sass", "scss", "pug", "typescriptreact",
            },
            init_options = {
                includeLanguages = {},
                excludeLanguages = {},
                extensionsPath = {},
                preferences = {},
                showAbbreviationSuggestions = true,
                showExpandedAbbreviation = "always",
                showSuggestionsAsSnippets = false,
                syntaxProfiles = {},
                variables = {},
            },
        })
        vim.lsp.enable("emmet_language_server")

        -- Emmet LS alternative
        vim.lsp.config("emmet_ls", {
            filetypes = {
                "html", "typescriptreact", "javascriptreact",
                "css", "sass", "scss", "less", "svelte",
            },
        })
        vim.lsp.enable("emmet_ls")

        -- TypeScript / JavaScript
        local lspconfig_util = require("lspconfig.util")

        local vtsls_available = vim.fn.executable("vtsls") == 1

        if vtsls_available then
            vim.lsp.config("vtsls", {
                root_dir = lspconfig_util.root_pattern("tsconfig.json", "angular.json", "package.json", ".git"),
                settings = {
                    typescript = {
                        preferences = {
                            importModuleSpecifier = "non-relative",
                            includeCompletionsForModuleExports = true,
                            includeCompletionsForImportStatements = true,
                        },
                    },
                    javascript = {
                        preferences = {
                            importModuleSpecifier = "non-relative",
                        },
                    },
                },
            })
            vim.lsp.enable("vtsls")
        else
            vim.lsp.config("ts_ls", {
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                single_file_support = false,
                root_dir = lspconfig_util.root_pattern("tsconfig.json", "package.json", ".git"),
                init_options = {
                    preferences = {
                        includeCompletionsForModuleExports = true,
                        includeCompletionsForImportStatements = true,
                    },
                },
            })
            vim.lsp.enable("ts_ls")
        end

        -- Go
        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    analyses = { unusedparams = true },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })
        vim.lsp.enable("gopls")
    end,
}
