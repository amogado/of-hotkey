# of-hotkey

Global keyboard shortcuts that pop the **OmniFocus Quick Entry** panel already
targeted at a specific project — from *any* app on your Mac.

Press a key from Safari, Mail, your terminal, wherever: the real Quick Entry
window appears, with the project pre-filled. You still get the full panel —
edit the title, change the project, add tags/dates/flag — before saving.

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

**1. Find your project IDs.** With OmniFocus running:

```sh
of-hotkey-projects
```

Each line is `<folder path>\t<project id>`. Copy the ID of the project you want.
The ID is unique even when two projects share a name.

**2. Add bindings** to `~/.hammerspoon/init.lua`:

```lua
local ofhotkey = require("of-hotkey")

ofhotkey.bind({
  { key = "E", project = "aBcDeFgH123" },                          -- ⌃⌥⌘E
  { key = "N", project = "Zy9WvUtSr-0", mods = { "cmd", "alt" } }, -- ⌥⌘N
})
```

`mods` is optional and defaults to `{ "ctrl", "alt", "cmd" }`.

> Installed via Homebrew? Point Lua at the formula instead of relying on the
> symlink:
> ```lua
> package.path = "#{brew --prefix}/opt/of-hotkey/libexec/?.lua;" .. package.path
> ```
> (Run `brew --prefix` once and paste the absolute path.)

**3. Reload Hammerspoon** (menubar ▸ Reload Config, or restart it). Then press
your hotkey from any app.

## API

`require("of-hotkey")` returns a table with:

- `openProject(id)` — open Quick Entry pre-set to the project with that ID.
- `bind(specs)` — bind a list of `{ key = , project = , mods = }` specs.
- `defaultMods` — the fallback modifier combo (`{ "ctrl", "alt", "cmd" }`).

## License

[PolyForm Noncommercial 1.0.0](LICENSE.md).
