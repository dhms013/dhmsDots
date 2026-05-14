local home = os.getenv("HOME") or ""

return {
	home = home,
	confPath = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config"),
	dhmsDots = (home .. "/.dhmsDots"),
}
