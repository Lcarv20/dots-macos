return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = true },
	keys = {
		{
			"<leader>ft",
			"<cmd>TodoTelescope<cr>",
			desc = "Todo Telescope",
		},
		{
			"<leader>fT",
			"<cmd>TodoTrouble<cr>",
			desc = "Todo Trouble",
		},
	},
}
