starship init fish | source

set -gx PATH /home/sebas2/.npm-global/bin $PATH
set -gx JAVA_HOME /usr/lib/jvm/java-26-openjdk
set -g fish_greeting

# Load pywal colors
if test -e ~/.cache/wal/colors.fish
    source ~/.cache/wal/colors.fish
end

# Created by `pipx` on 2025-08-21 17:22:22
set PATH $PATH /home/sebas2/.local/bin
set -Ux PATH $HOME/.npm-global/bin $PATH

# Alias

alias ls lsd
alias m "udisksctl mount -b"
alias um "udisksctl unmount -b"
alias fetch neofetch
alias s "yay -Ss"
alias S "yay -S --noconfirm"
function venv
    set dir (pwd)

    while test $dir != /
        if test -f "$dir/.venv/bin/activate.fish"
            source "$dir/.venv/bin/activate.fish"
            echo "Activated virtualenv at $dir/.venv"
            return
        end
        set dir (dirname $dir)
    end

    echo "No .venv found in this directory or any parent."
end

function cfiglet
    set prefix $argv[1]
    set text $argv[2..-1]

    figlet $text | sed "s/^/$prefix /"
end

function dstow
    stow -t $HOME $argv
end

# OpenClaw Completion
test -f "/home/sebas/.openclaw/completions/openclaw.fish"; and source "/home/sebas/.openclaw/completions/openclaw.fish"

cowsay -f sus "Hi!"

# Added by Antigravity CLI installer
set -gx PATH "/home/sebas/.local/bin" $PATH
