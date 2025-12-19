#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"

alias ls='eza -l'
alias lsa='eza -l -a'
alias lt='eza -l --tree --level=2'
alias lta='eza -l -a --tree --level=2'
alias grep='grep --color=auto'
alias waybar="systemctl --user restart waybar.service"
alias fastfetch="clear; ~/.config/fastfetch/ffetch_wrapper.sh"
alias lv='nvim $(fzf -m --preview="bat --color=always {}")'
alias expac="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 20"
alias icat="clear; kitty +kitten icat"
alias bashrc="clear; source ~/.bashrc"
alias duf="clear; duf"
alias update="sudo pacman -Syu --noconfirm; yay -Syu --noconfirm"
alias gadd="git add"
alias gcm="git commit -m"
alias gp="git push"
alias boo="ghostty +boo"
alias relog="sudo killall sddm"

export EDITOR="nvim"
export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=numbers --line-range :500 {}'"
export BAT_THEME="ansi"

fastfetch
eval "$(zoxide init bash)"
