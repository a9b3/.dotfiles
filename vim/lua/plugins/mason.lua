local masonInstalls = {
	"lua_ls",
	"ts_ls",
	"jsonls",
	"yamlls",
	"svelte",
	"gopls",
	"nil_ls",
}

-- https://neovim.io/doc/user/lsp.html
local lspConfigs = {
	{
		name = "lua_ls",
		override = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		},
	},
	{ name = "ts_ls", override = {} },
	{
		name = "jsonls",
		override = function()
			return {
				settings = {
					json = {
						validate = { enable = true },
						schemas = require("schemastore").json.schemas(),
					},
				},
			}
		end,
	},
	{
		name = "yamlls",
		override = function()
			return {
				settings = {
					yaml = {
						validate = true,
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			}
		end,
	},
	{ name = "svelte", override = { settings = { svelte = { plugin = { svelte = { compilerWarnings = {} } } } } } },
	{
		name = "gopls",
		override = function()
			return {
				cmd = { "gopls", "serve" },
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
				root_dir = require("lspconfig").util.root_pattern(".git", "go.mod"),
			}
		end,
	},
	{
		name = "nil_ls",
		override = function()
			return {
				root_dir = require("lspconfig").util.root_pattern("flake.nix", ".git"),
			}
		end,
	},
}

local on_attach_keybindings = function(_, _)
	vim.keymap.set(
		"n",
		"[d",
		"<cmd>Lspsaga diagnostic_jump_prev<cr>",
		{ remap = false, desc = "[lsp] Next diagnostic" }
	)
	vim.keymap.set(
		"n",
		"]d",
		"<cmd>Lspsaga diagnostic_jump_next<cr>",
		{ remap = false, desc = "[lsp] Previous diagnostic" }
	)
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { remap = false, desc = "[lsp] Declaration" })
	vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", { desc = "[lsp] Code actions" })
	vim.keymap.set("n", "<leader>lR", "<cmd>Lspsaga finder<cr>", { desc = "[lsp] Finder" })
	vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga peek_definition<cr>", { desc = "[lsp] Peek definition" })
	vim.keymap.set("n", "<leader>li", "<cmd>Lspsaga finder imp<cr>", { desc = "[lsp] Finder implementation" })
	vim.keymap.set("n", "<leader>lt", "<cmd>Lspsaga peek_type_definition<cr>", { desc = "[lsp] Peek type definition" })
	vim.keymap.set("n", "<leader>lc", "<cmd>Lspsaga hover_doc<cr>", { desc = "[lsp] Hover doc" })
	vim.keymap.set("n", "<leader>lo", "<cmd>Outline<cr>", { desc = "[lsp] Outline" })
	vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", { desc = "[lsp] Rename" })
end

-- mason installs LSP servers, linters, formatters
-- mason-lspconfig bridges mason.nvim and nvim-lspconfig mapping server names and setup
-- nvim-lspconfig supplies community defaults for lsp servers
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/schemastore.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for _, confs in ipairs(lspConfigs) do
				local override = (type(confs.override) == "function") and confs.override() or confs.override or {}
				vim.lsp.config(
					confs.name,
					vim.tbl_extend("force", override, {
						capabilities = capabilities,
						on_attach = on_attach_keybindings,
					})
				)
				vim.lsp.enable(confs.name)
			end
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = masonInstalls,
			automatic_installation = true,
		},
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
	},
}
