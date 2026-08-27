# of-hotkey

Global keyboard shortcuts that pop the **OmniFocus Quick Entry** panel already
targeted at a specific project — from *any* app on your Mac.

Press a key from Safari, Mail, your terminal, wherever: the real Quick Entry
window appears, with the project pre-filled. You still get the full panel —
edit the title, change the project, add tags/dates/flag — before saving.

It also gives you an always-visible **OmniFocus menu bar anchor** (so you never
lose OmniFocus), and can add OmniFocus to your **login items**.

## Why not just OmniFocus?

- OmniFocus has **no native "default project"** for Quick Entry: captured items
  land in the Inbox.
- Its URL scheme (`omnifocus:///add?project=NAME`) can pre-fill a project, but
  it matches by **name** — so it silently breaks when two projects share a name
  (e.g. several `Normal Run` across different client folders).
- There is **no Omni Automation API** to pre-fill the Quick Entry window
  (`quickEntry` is not a global in omniJS).

`of-hotkey` sidesteps all of this by targeting a project by its **unique ID**
(`omnifocus:///add?project=<id>&autosave=false`), triggered by a global
[Hammerspoon](https://www.hammerspoon.org) hotkey. The trigger is 100 %
Hammerspoon (system-wide); OmniFocus only does the capture.

## Requirements

- macOS with [OmniFocus 4](https://www.omnigroup.com/omnifocus)
- [Hammerspoon](https://www.hammerspoon.org) (`brew install --cask hammerspoon`)

## Install

### Homebrew (recommended)

```sh
brew install amogado/tap/of-hotkey
```

### Manual

```sh
git clone https://github.com/amogado/of-hotkey.git
cd of-hotkey && ./install.sh
```

`install.sh` symlinks `of-hotkey.lua` into `~/.hammerspoon/` and
`of-hotkey-projects` into `~/bin/`.

## Setup

**1. Wire it into Hammerspoon.** `of-hotkey-setup` idempotently adds a managed
block to `~/.hammerspoon/init.lua` (`install.sh` runs it for you; after
`brew install`, run it once). It is safe to re-run — it only adds the block when
it's missing, and never touches bindings you put inside it:

```sh
of-hotkey-setup
```

This inserts:

```lua
-- >>> of-hotkey (managed) >>>
package.path = "…/opt/of-hotkey/libexec/?.lua;" .. package.path
local ok_ofhotkey, ofhotkey = pcall(require, "of-hotkey")
if ok_ofhotkey then
  ofhotkey.setup({
    menubar = true,  -- always-visible OmniFocus menubar anchor
    bindings = {
      -- One line per project. List IDs with:  of-hotkey-projects
      -- { key = "E", project = "PASTE_PROJECT_ID", label = "My Project" },
    },
  })
end
-- <<< of-hotkey <<<
```

To also launch OmniFocus at login, run it once with `--autostart` (idempotent):

```sh
of-hotkey-setup --autostart
```

**2. Find your project IDs.** With OmniFocus running:

```sh
of-hotkey-projects
```

Each line is `<folder path>\t<project id>`. The ID is unique even when two
projects share a name.

**3. Add your bindings** inside the managed block:

```lua
ofhotkey.setup({
  menubar = true,
  bindings = {
    { key = "E", project = "aBcDeFgH123", label = "Ephais" },                          -- ⌃⌥⌘E
    { key = "N", project = "Zy9WvUtSr-0", label = "Notes", mods = { "cmd", "alt" } },   -- ⌥⌘N
  },
})
```

`mods` is optional (defaults to `{ "ctrl", "alt", "cmd" }`); `label` is optional
(shown in the menu bar; falls back to the project ID).

**4. Reload Hammerspoon** (menubar ▸ Reload Config, or restart it). Then press
your hotkey from any app, or click the OmniFocus menu bar icon.

> Re-run `of-hotkey-setup --force` to rewrite the wiring line after a move
> (this resets the bindings inside the block).

## API

`require("of-hotkey")` returns a table with:

- `setup{ bindings = {...}, menubar = true|false }` — bind hotkeys and,
  optionally, show the always-visible OmniFocus menu bar anchor. Both are driven
  by the same `bindings` list.
- `openProject(id)` — open Quick Entry pre-set to the project with that ID.
- `bind(specs)` — bind a list of `{ key = , project = , mods = }` specs.
- `menubar(specs)` — create just the menu bar anchor from a list of specs.
- `defaultMods` — the fallback modifier combo (`{ "ctrl", "alt", "cmd" }`).

## License

[PolyForm Noncommercial 1.0.0](LICENSE.md).
