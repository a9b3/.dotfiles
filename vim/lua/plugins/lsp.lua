local masonInstalls = {
	"stylua",
	"shfmt",
	"eslint_d",
	"prettierd",
}

local masonLspInstalls = {
	"lua_ls",
	"tsserver",
}

local on_attach_keybindings = function(_, _)
	local key_opts = { remap = false }

	vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { remap = false, desc = "[lsp] Next diagnostic" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { remap = false, desc = "[lsp] Previous diagnostic" })
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { remap = false, desc = "[lsp] Declaration" })
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "[lsp] Code actions" })
	vim.keymap.set("n", "<leader>lR", "<cmd>Telescope lsp_references<cr>", key_opts)
	vim.keymap.set("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", key_opts)
	vim.keymap.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", key_opts)
	vim.keymap.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", key_opts)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				sync_install = false,
				auto_install = true,
				-- List of parsers to ignore installing (or "all")
				ignore_install = { "javascript" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},
			})
		end,
	},
	{
		"github/copilot.vim",
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = masonInstalls,
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	"williamboman/mason-lspconfig.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = masonLspInstalls,
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				on_attach = on_attach_keybindings,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			lspconfig.tsserver.setup({
				on_attach = on_attach_keybindings,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.code_actions.eslint_d,
				},
				on_attach = function(client, bufnr)
					if client.name == "null-ls" and client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
}
