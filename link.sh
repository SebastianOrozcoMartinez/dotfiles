#!/usr/bin/env bash
set -e

DOTFILES="$HOME/Proyects/dotfiles"
CONFIG="$HOME/.config"

echo "Linking dotfiles from $DOTFILES"

mkdir -p "$CONFIG"

for dir in "$DOTFILES/.config/"*; do
  name=$(basename "$dir")
  target="$CONFIG/$name"

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Removing $target"
    rm -rf "$target"
  fi

  echo "Linking $name"
  ln -s "$dir" "$target"
done

echo "Done."
