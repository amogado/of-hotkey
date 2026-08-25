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
chmod +x "$REPO_DIR/bin/of-hotkey-projects" "$REPO_DIR/bin/of-hotkey-setup"
ln -sf "$REPO_DIR/bin/of-hotkey-projects" "$BIN_DIR/of-hotkey-projects"
ln -sf "$REPO_DIR/bin/of-hotkey-setup" "$BIN_DIR/of-hotkey-setup"

# Idempotently add the managed block to ~/.hammerspoon/init.lua.
"$REPO_DIR/bin/of-hotkey-setup"

print ""
print "of-hotkey installed:"
print "  • $HS_DIR/of-hotkey.lua       (Hammerspoon module)"
print "  • $BIN_DIR/of-hotkey-projects  (list your project IDs)"
print "  • $BIN_DIR/of-hotkey-setup     (idempotent init.lua wiring)"
print ""
print "Next: put your project IDs in the of-hotkey block of ~/.hammerspoon/init.lua,"
print "then reload Hammerspoon."
