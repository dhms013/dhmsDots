local active_border_color = "rgb({{ accent_strip }})"

hl.config({
  general = {
    col = {
			active_border = {
				colors = { active_border_color, active_border_color, active_border_color, "rgba(000000ff)" },
				angle = 35,
			},
    },
  },

  group = {
    col = {
      border_active = active_border_color,
    },
  },
})
