# Set TrueColor support
#set -g default-terminal "xterm-256color"
#set -g terminal-overrides ",*256col*:Tc"

# Hide fish greeting
set fish_greeting

# Some useful aliases
alias del="trash"
alias c="clear"
alias fconf="nano ~/.config/fish/config.fish"
alias tconf="nano ~/.tmux.conf"
alias vconf="nano ~/.config/nvim/init.vim"

# Debian-based distros only
alias sai="sudo apt install"
alias sau="sudo apt update"

# Fish command history
function history
    builtin history --show-time='%F %T '
end

# Easy file backup
function backup --argument filename
    cp $filename $filename.bak
end

# Replace ls with exa
alias la='exa -al --color=always --group-directories-first' # preferred listing
alias ls='exa  --color=always --group-directories-first'    # not dotted files and dirs
alias lsa='exa -a --color=always --group-directories-first' # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.="exa -a | egrep '^\.'"                             # show only dotfiles

export PATH="$PATH:/home/arslee/flutter/bin"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export PATH="$PATH":"/home/arslee/.pub-cache/bin"
export PATH="$PATH":"/home/arslee/.local/bin"

export MICRO_TRUECOLOR=1
export BAT_THEME=Dracula

starship init fish | source

if status is-interactive
    bash ~/.config/fish/theme.sh
end
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

clear
