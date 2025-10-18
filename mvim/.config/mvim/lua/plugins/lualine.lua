return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- enabled = false,
		lazy = true,
		event = "VeryLazy",
		config = function()
			local themes = require("utils.configs.lualine_configs")
			require("lualine").setup(themes.lcarv_shrugged())
			-- require("lualine").setup(themes.cosmicink())
		end,
	},
}
