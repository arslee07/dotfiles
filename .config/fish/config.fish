export COLORTERM=truecolor # force truecolor

set fish_greeting

alias c="clear"

export PATH="$PATH":~/.local/bin
export PATH="$PATH":~/.cargo/bin
export PATH="$PATH":~/flutter/bin
export PATH="$PATH":~/.pub-cache/bin
export PATH="$PATH":~/Android/cmdline-tools/latest/bin
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export BAT_THEME=base16
export GPG_TTY=$(tty)
export GPG_AGENT_INFO
export EDITOR=hx

function fish_prompt
     set -l last_status $status
     echo -nse "\n" (set_color $fish_color_cwd) (prompt_pwd) (set_color grey) (fish_vcs_prompt) "\n" (if test $last_status -eq 0; set_color -o green; else; set_color -o red; end) ">" (set_color normal) " "
end

clear
