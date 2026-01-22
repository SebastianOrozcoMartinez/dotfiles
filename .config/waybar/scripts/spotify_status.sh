#!/usr/bin/env bash
playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || echo "Spotify stopped"
