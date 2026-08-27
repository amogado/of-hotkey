-- of-hotkey — global hotkeys + an always-visible menubar anchor that open the
-- OmniFocus Quick Entry panel pre-targeted to a specific project.
--
-- OmniFocus has no native "default project" for Quick Entry, and its URL scheme
-- (omnifocus:///add?project=NAME) matches projects by *name* — which breaks
-- silently when two projects share a name. of-hotkey targets a project by its
-- unique ID instead. The real Quick Entry window still opens: you can edit the
-- title, change the project, add tags/dates, etc. before saving.
--
-- Usage (in ~/.hammerspoon/init.lua) — `of-hotkey-setup` writes this for you:
--   local ofhotkey = require("of-hotkey")
--   ofhotkey.setup({
--     menubar = true,   -- always-visible OmniFocus menubar anchor
--     bindings = {
--       { key = "E", project = "aBcDeFgH123", label = "Ephais" },
--       { key = "B", project = "Zy9WvUtSr-0", label = "Normal Run", mods = { "cmd", "alt" } },
--     },
--   })
--
-- Find project IDs with:  of-hotkey-projects

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
function M.bind(specs)
  for _, s in ipairs(specs or {}) do
    hs.hotkey.bind(s.mods or M.defaultMods, s.key, function()
      M.openProject(s.project)
    end)
  end
end

local MOD_SYMBOL = { ctrl = "⌃", alt = "⌥", cmd = "⌘", shift = "⇧" }

local function combo(spec)
  local out = ""
  for _, m in ipairs(spec.mods or M.defaultMods) do out = out .. (MOD_SYMBOL[m] or "") end
  return out .. (spec.key or "")
end

-- Kept as a module field so the menubar object isn't garbage-collected.
M._menubar = nil

-- Always-visible, clickable OmniFocus anchor in the system menu bar. The menu
-- lists "open OmniFocus" plus one quick-capture entry per binding spec.
function M.menubar(specs)
  if M._menubar then M._menubar:delete(); M._menubar = nil end
  local mb = hs.menubar.new()
  if not mb then return nil end

  local icon = hs.image.imageFromAppBundle("com.omnigroup.OmniFocus4")
  if icon then mb:setIcon(icon:setSize({ w = 18, h = 18 })) else mb:setTitle("OF") end
  mb:setTooltip("OmniFocus")

  local menu = {
    { title = "Ouvrir OmniFocus", fn = function() hs.application.launchOrFocus("OmniFocus") end },
    { title = "-" },
  }
  for _, s in ipairs(specs or {}) do
    menu[#menu + 1] = {
      title = "Capture → " .. (s.label or s.project) .. "  (" .. combo(s) .. ")",
      fn = function() M.openProject(s.project) end,
    }
  end
  menu[#menu + 1] = {
    title = "Capture (vierge)",
    fn = function() hs.urlevent.openURL("omnifocus:///add?autosave=false") end,
  }
  mb:setMenu(menu)

  M._menubar = mb
  return mb
end

-- Convenience: bind hotkeys and (optionally) show the always-visible menubar,
-- both driven by the same list of specs.
function M.setup(opts)
  opts = opts or {}
  local specs = opts.bindings or {}
  M.bind(specs)
  if opts.menubar then M.menubar(specs) end
end

return M
