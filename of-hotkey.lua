-- of-hotkey — global hotkeys that open the OmniFocus Quick Entry panel
-- pre-targeted to a specific project.
--
-- OmniFocus has no native "default project" for Quick Entry, and its URL
-- scheme (omnifocus:///add?project=NAME) matches projects by *name* — which
-- breaks silently when two projects share a name (e.g. several "Normal Run").
-- of-hotkey targets a project by its unique ID instead, so the right project
-- is always pre-filled. The real Quick Entry window still opens: you can edit
-- the title, change the project, add tags/dates, etc. before saving.
--
-- Usage (in ~/.hammerspoon/init.lua):
--   local ofhotkey = require("of-hotkey")
--   ofhotkey.bind({
--     { key = "E", project = "aBcDeFgH123" },
--     { key = "B", project = "Zy9WvUtSr-0", mods = { "ctrl", "alt", "cmd" } },
--   })
--
-- Find your project IDs with:  bin/of-hotkey-projects

local M = {}

-- Default modifier combo for bindings that don't specify their own.
M.defaultMods = { "ctrl", "alt", "cmd" }

-- Open the Quick Entry panel pre-set to the project with the given ID.
-- autosave=false => the window opens and waits for you (nothing hits the Inbox).
function M.openProject(projectId)
  local url = "omnifocus:///add?project=" .. hs.http.encodeForQuery(projectId) .. "&autosave=false"
  hs.urlevent.openURL(url)
end

-- Bind a list of specs: { { key = "E", project = "<id>", mods = {...} }, ... }
-- mods is optional and falls back to M.defaultMods.
function M.bind(specs)
  for _, s in ipairs(specs) do
    hs.hotkey.bind(s.mods or M.defaultMods, s.key, function()
      M.openProject(s.project)
    end)
  end
end

return M
