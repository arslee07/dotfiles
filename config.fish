# Set TrueColor support
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Hide fish greeting
set fish_greeting

# Some useful aliases
alias del="trash"
alias sai="sudo apt install"
alias sau="sudo apt update"
alias c="clear"
alias fconf="nano ~/.config/fish/config.fish"
alias tconf="nano ~/.tmux.conf"
alias vconf="nano ~/.config/nvim/init.vim"

# Fish command history
function history
    builtin history --show-time='%F %T '
end

# Bobthefish settings
set -g theme_color_scheme dracula
set -g theme_date_format "+%a %H:%M"
set -g theme_display_user ssh
set -g theme_display_hostname no

# Easy file backup
function backup --argument filename
    cp $filename $filename.bak
end

# Replace ls with exa
alias la='exa -al --color=always --group-directories-first --icons' # preferred listing
alias ls='exa  --color=always --group-directories-first --icons'    # not dotted files and dirs
alias lsa='exa -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

# Replace du with dust
alias du="dust"

# Replace cat with bat
alias cat="batcat"

clear
PF_COL1=4 PF_COL2=4 PF_COL3=4 pfetch
