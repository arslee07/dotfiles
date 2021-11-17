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
alias la='exa -al --color=always --group-directories-first --icons' # preferred listing
alias ls='exa  --color=always --group-directories-first --icons'    # not dotted files and dirs
alias lsa='exa -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

# Replace du with dust
alias du="dust"

# Replace cat with bat
alias cat="bat"

export PATH="$PATH:/home/arslee/flutter/bin"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export PATH="$PATH":"/home/arslee/.pub-cache/bin"
export PATH="$PATH":"/home/arslee/.local/bin"

export MICRO_TRUECOLOR=1
export BAT_THEME=Dracula

starship init fish | source

clear
