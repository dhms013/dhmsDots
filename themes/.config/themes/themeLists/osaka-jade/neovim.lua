-- return {
-- 	"ribru17/bamboo.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("bamboo").setup({})
-- 		require("bamboo").load()
-- 	end,
-- }
return {
	{ "ribru17/bamboo.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "bamboo",
		},
	},
}
