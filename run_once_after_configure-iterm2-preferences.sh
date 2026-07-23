#!/bin/sh
set -eu

prefs_dir="$HOME/.config/iterm2"
prefs_file="$prefs_dir/com.googlecode.iterm2.plist"

[ -f "$prefs_file" ] || exit 0

# Import only while iTerm is stopped; it will load this same file on next launch.
if ! pgrep -x iTerm2 >/dev/null 2>&1; then
  defaults import com.googlecode.iterm2 "$prefs_file"
fi

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$prefs_dir"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
