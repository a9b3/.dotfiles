-- check this for valid mason installs
-- https://mason-registry.dev/registry/list
local masonInstalls = {
	"stylua",
	"shfmt",
	"eslint_d",
	"prettier",
	"luacheck", -- requires luarocks executable in runtimepath
	"json-lsp",
	"yaml-language-server",
	"svelte-language-server",
	"goimports",
	"gopls",
	"nil",
	"nixpkgs-fmt",
	"buildifier",
}

-- check this for valid server names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
-- {string, [setup = function()]}
local masonLspConfigs = {
	{
		"lua_ls",
		setup = function(opts)
			require("neodev").setup({})

			require("lspconfig").lua_ls.setup(vim.tbl_extend("force", opts, {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			}))
		end,
	},
	{
		"tsserver",
		setup = function(opts)
			require("lspconfig").tsserver.setup(opts)
		end,
	},
	{
		"jsonls",
		setup = function(opts)
			require("lspconfig").jsonls.setup(vim.tbl_extend("force", opts, {
				settings = {
					json = {
						validate = { enable = true },
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").json.schemas({
							select = {
								"package.json",
								"tsconfig.json",
								"jsconfig.json",
								".eslintrc",
								"prettierrc.json",
							},
						}),
					},
				},
			}))
		end,
	},
	{
		"yamlls",
		setup = function(opts)
			require("lspconfig").yamlls.setup(vim.tbl_extend("force", opts, {
				settings = {
					yaml = {
						validate = true,

						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas({
							-- select subset from the JSON schema catalog
							select = {
								"kustomization.yaml",
								"docker-compose.yml",
							},
						}),
					},
				},
			}))
		end,
	},
	{
		"svelte",
		setup = function(opts)
			require("lspconfig").svelte.setup(vim.tbl_extend("force", opts, {
				settings = {
					svelte = {
						plugin = {
							svelte = {
								compilerWarnings = {},
							},
						},
					},
				},
			}))
		end,
	},
	{
		"gopls",
		setup = function(opts)
			require("lspconfig").gopls.setup(vim.tbl_extend("force", opts, {
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
			}))
		end,
	},
	{
		"nil_ls",
		setup = function(opts)
			require("lspconfig").nil_ls.setup(vim.tbl_extend("force", opts, {
				root_dir = require("lspconfig").util.root_pattern("flake.nix", ".git"),
			}))
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

return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" } },
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
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local extractedKeys = vim.tbl_map(function(entry)
				return type(entry) == "string" and entry or entry[1]
			end, masonLspConfigs)

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = extractedKeys,
				automatic_installation = true,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for _, entry in ipairs(masonLspConfigs) do
				if type(entry) == "table" and entry.setup then
					entry.setup({
						capabilities = capabilities,
						on_attach = on_attach_keybindings,
					})
				end
			end
		end,
	},
}
