add_newline = true
command_timeout = 300
format = "[$directory$git_branch$git_status]($style)$character"

# Username module
[username]
show_always = true
style_user = "bg:{{ background }} fg:{{ accent }}"
style_root = "bg:{{ background }} fg:{{ accent }}"
format = '[$user ]($style)'
disabled = false

# Character module for the prompt symbol
[character]
success_symbol = '[➜](bold fg:{{ accent }})'
error_symbol = '[✗](bold red)'
vicmd_symbol = '[❮](fg:{{ accent }})'

[directory]
# truncation_length = 2
# truncation_symbol = "…/"
repo_root_style = "bold fg:#00cc77"
repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) "
style = "fg:{{ accent }}"
format = "[$path]($style)"

[git_branch]
format = "[$symbol $branch]($style) "
symbol = "󰘬"
style = "italic fg:{{ accent }}"

[git_status]
format     = '[$all_status]($style)'
# format     = '[$all_status$ahead_behind]($style)'
style      = "fg:{{ accent }}"
ahead      = "⇡${count} "
diverged   = "⇕⇡${ahead_count}⇣${behind_count} "
behind     = "⇣${count} "
conflicted = " "
up_to_date = " "
untracked  = "? "
modified   = " "
stashed    = ""
staged     = ""
renamed    = ""
deleted    = ""

# Path substitutions for cleaner display
[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "
"Desktop" = "󰀾 "
"Videos" = "󰕧 "
"Public" = "󰐕 "
"Templates" = "󰏗 "

# Programming language modules
 [aws]
symbol = "  "

[buf]
symbol = " "

[c]
format = "[$symbol ]($style)"
disabled = true

[conda]
symbol = " "

[crystal]
symbol = " "

[dart]
symbol = " "

[docker_context]
symbol = "󰡨 "
style = "bg:#ccffee fg:#000000"
format = '[ $symbol $context ]($style)'
         
[elixir]
symbol = " "

[elm]
symbol = " "

[fennel]
symbol = " "

[golang]
symbol = "󰟓 "
style = "bg:#383838 fg:#00ff99"
format = '[ $symbol ($version) ]($style)'

[guix_shell]
symbol = " "

[haskell]
symbol = " "

[haxe]
symbol = " "

[java]
symbol = "󰸭 "
style = "bg:#383838 fg:#00ff99"
format = '[ $symbol ($version) ]($style)'

[julia]
symbol = " "

[kotlin]
symbol = " "

[lua]
symbol = " "

[nodejs]
symbol = "󰌞󰛦"
style = "bg:#383838 fg:#00ff99"
format = '[ $symbol ($version) ]($style)'

[ocaml]
symbol = " "

[package]
symbol = "󰏗 "

[perl]
symbol = " "

[php]
symbol = " "

[python]
version_format = "${raw}"
symbol = " 🐍 "
style = "bg:#383838 fg:#00ff99"
format = '[${symbol}${version} 󰌠($virtualenv)󰌠 ]($style)'

[rlang]
symbol = "󰟔 "

[ruby]
symbol = " "

[rust]
symbol = "󱘗"
style = "bg:#383838 fg:#00ff99"
format = '[ $symbol ($version) ]($style)'

[scala]
symbol = " "

[swift]
symbol = " "

[zig]
symbol = " "

[gradle]
symbol = " "

[os.symbols]
Alpaquita = " "
Alpine = " "
AlmaLinux = " "
Amazon = " "
Android = " "
Arch = " "
Artix = " "
CentOS = " "
Debian = " "
DragonFly = " "
Emscripten = " "
EndeavourOS = " "
Fedora = " "
FreeBSD = " "
Garuda = "󰛓 "
Gentoo = " "
HardenedBSD = "󰞌 "
Illumos = "󰈸 "
Kali = " "
Linux = " "
Mabox = " "
Macos = " "
Manjaro = " "
Mariner = " "
MidnightBSD = " "
Mint = " "
NetBSD = " "
NixOS = " "
OpenBSD = "󰈺 "
openSUSE = " "
OracleLinux = "󰌷 "
Pop = " "
Raspbian = " "
Redhat = " "
RedHatEnterprise = " "
RockyLinux = " "
Redox = "󰀘 "
Solus = "󰠳 "
SUSE = " "
Ubuntu = " "
Unknown = " "
Void = " "
Windows = "󰍲 "
