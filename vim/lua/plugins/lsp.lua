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
	vim.keymap.set("n", "<leader>lc", "<cmd>Lspsaga hover_doc<cr>", { desc = "[lsp] Hover doc" })
end

-- check this for valid mason installs
-- https://mason-registry.dev/registry/list
local masonInstalls = {
	"stylua",
	"shfmt",
	"eslint_d",
	"prettier",
	"luacheck", -- requires luarocks executable in runtimepath
	"json-lsp",
}

-- check this for valid server names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
-- {string, [setup = function()]}
local masonLspInstalls = {
	{
		"lua_ls",
		setup = function()
			require("lspconfig").lua_ls.setup({
				on_attach = on_attach_keybindings,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},
	{
		"tsserver",
		setup = function()
			require("lspconfig").tsserver.setup({ on_attach = on_attach_keybindings })
		end,
	},
	{
		"jsonls",
		setup = function()
			require("lspconfig").jsonls.setup({ on_attach = on_attach_keybindings })
		end,
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
				sync_install = false,
				auto_install = true,
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
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
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
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			local lspInstalls = vim.tbl_map(function(entry)
				return type(entry) == "string" and entry or entry[1]
			end, masonLspInstalls)

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = lspInstalls,
				automatic_installation = true,
			})

			for _, entry in ipairs(masonLspInstalls) do
				if type(entry) == "table" and entry.setup then
					entry.setup()
				end
			end
		end,
	},
}
