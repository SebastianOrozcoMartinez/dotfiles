#!/usr/bin/env bash
set -euo pipefail

PROFILE_DIR="$HOME/.config/hypr/modules/profiles"
CURRENT="$PROFILE_DIR/current"

# Detect profile
if hyprctl monitors all | grep -q "XZL XZ3015"; then
  TARGET="docked"
else
  TARGET="portable"
fi

# Already active?
CURRENT_TARGET="$(readlink "$CURRENT" 2>/dev/null || true)"

if [ "$CURRENT_TARGET" = "$TARGET" ]; then
  exit 0
fi

echo "Switching Hypr profile to: $TARGET"

ln -sfn "$TARGET" "$CURRENT"

hyprctl reload
