set -gx PATH /home/sebas2/.npm-global/bin $PATH
set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
    pokemon-colorscripts -r --no-title
end
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
