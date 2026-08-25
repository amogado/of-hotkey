#!/bin/zsh
# of-hotkey installer — makes the Hammerspoon module and the project lister
# available on your system.
#
#   ~/.hammerspoon/of-hotkey.lua  -> symlink to this repo's of-hotkey.lua
#   ~/bin/of-hotkey-projects       -> symlink to this repo's bin/of-hotkey-projects
#
# After running, add the bindings to ~/.hammerspoon/init.lua (see README).
set -eu

REPO_DIR="${0:A:h}"
HS_DIR="$HOME/.hammerspoon"
BIN_DIR="$HOME/bin"

mkdir -p "$HS_DIR" "$BIN_DIR"

ln -sf "$REPO_DIR/of-hotkey.lua" "$HS_DIR/of-hotkey.lua"
chmod +x "$REPO_DIR/bin/of-hotkey-projects"
ln -sf "$REPO_DIR/bin/of-hotkey-projects" "$BIN_DIR/of-hotkey-projects"

print "of-hotkey installed:"
print "  • $HS_DIR/of-hotkey.lua      (require \"of-hotkey\" from init.lua)"
print "  • $BIN_DIR/of-hotkey-projects (run it to list your project IDs)"
print ""
print "Next: add your bindings to ~/.hammerspoon/init.lua — see the README."
