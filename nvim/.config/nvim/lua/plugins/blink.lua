return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab", -- Sets Tab to accept/confirm
      -- Optional: Disable Enter for completion entirely
      ["<CR>"] = { "fallback" },
    },
  },
}
