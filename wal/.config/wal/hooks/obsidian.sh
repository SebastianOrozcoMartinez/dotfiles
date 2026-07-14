#!/bin/sh
set -e

WAL="$HOME/.cache/wal/colors.json"
OB_APPEARANCE="$HOME/Documents/VoidVault/.obsidian/appearance.json"
OB_FILECOLOR="$HOME/Documents/VoidVault/.obsidian/plugins/obsidian-file-color/data.json"

[ -f "$WAL" ] || exit 1
[ -f "$OB_APPEARANCE" ] || exit 1
[ -f "$OB_FILECOLOR" ] || exit 1

ACCENT=$(jq -r '.colors.color3' "$WAL")

tmp=$(mktemp)
tmp2=$(mktemp)
trap 'rm -f "$tmp" "$tmp2"' EXIT

# Accent color (no mercy)
jq --arg accent "$ACCENT" \
  '.accentColor = $accent' \
  "$OB_APPEARANCE" >"$tmp" && mv "$tmp" "$OB_APPEARANCE"

# File-color plugin (blind overwrite, no fallback, no questions asked)
jq --slurpfile wal "$WAL" '
  .palette |= map(
    . as $entry |
    ($entry.name) as $colorname |
    .value = $wal[0].colors[$colorname]
  )
' "$OB_FILECOLOR" >"$tmp2" && mv "$tmp2" "$OB_FILECOLOR"

# Reload ONLY if obsidian is running
if pgrep -f obsidian >/dev/null; then
  obsidian plugin:reload id=obsidian-file-color >/dev/null 2>&1
fi
