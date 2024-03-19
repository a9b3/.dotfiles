std = {
	globals = {
		os = { other_fields = true },
		std = { other_fields = true },
		vim = { other_fields = true },
		require = { other_fields = true },
		ipairs = { other_fields = true },
		type = { other_fields = true },
		package = { other_fields = true },
		loadfile = { other_fields = true },
		table = { other_fields = true },
		_G = { other_fields = true },
	},
	diagnostics = {
		disable = { "lowercase-global" },
	},
}
