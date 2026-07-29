starship init fish | source

set -gx JAVA_HOME /usr/lib/jvm/java-26-openjdk
set -g fish_greeting ""
set -gx PATH $HOME/.npm-global/bin $HOME/.local/bin $PATH

function __reload_pywal --on-signal USR1
    source ~/.cache/wal/colors.fish
    kitty @ set-colors ~/.cache/wal/colors.ini 2>/dev/null
    starship init fish | source
end

# Load pywal colors
if test -e ~/.cache/wal/colors.fish
    source ~/.cache/wal/colors.fish
    kitty @ set-colors ~/.cache/wal/colors.ini 2>/dev/null
    starship init fish | source
end

# Alias

alias ls lsd
alias m "udisksctl mount -b"
alias um "udisksctl unmount -b"
alias fetch neofetch
alias s "yay -Ss"
alias S "yay -S --noconfirm"
alias cat bat

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

function ac
    arduino-cli compile --fqbn arduino:avr:uno
end
function au
    arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno
end

# OpenClaw Completion
test -f "/home/sebas/.openclaw/completions/openclaw.fish"; and source "/home/sebas/.openclaw/completions/openclaw.fish"

# Only show fastfetch in first terminal session
if not pgrep -x fish >/dev/null
    fastfetch
end

# Added by Antigravity CLI installer
set -gx PATH "/home/sebas/.local/bin" $PATH
