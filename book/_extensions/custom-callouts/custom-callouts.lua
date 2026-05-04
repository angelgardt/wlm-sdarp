-- custom-callouts.lua
-- Quarto >= 1.3
-- Native implementation via quarto.Callout()

local CALLS = {
  ["callout-history"] = {
    prefix = "hst",
    icon = "book",
    title_key = "callout-history-title",
    crossref_key = "crossref-hst-title"
  },

  ["callout-person"] = {
    prefix = "prs",
    icon = "person-circle",
    title_key = "callout-person-title",
    crossref_key = "crossref-prs-title"
  },

  ["callout-dataset"] = {
    prefix = "dts",
    icon = "database",
    title_key = "callout-dataset-title",
    crossref_key = "crossref-dts-title"
  },

  ["callout-myth"] = {
    prefix = "mth",
    icon = "exclamation-diamond",
    title_key = "callout-myth-title",
    crossref_key = "crossref-mth-title"
  }
}

-- helpers
local function has_class(el, class)
  for _, c in ipairs(el.classes or {}) do
    if c == class then return true end
  end
  return false
end

local function find_callout(el)
  for cls, meta in pairs(CALLS) do
    if has_class(el, cls) then
      return cls, meta
    end
  end
end

local function normalize_bool(v)
  return v == true or v == "true"
end

local function normalize_appearance(v)
  if v == "simple" or v == "minimal" then
    return v
  end
  return "default"
end


-- MAIN
function Div(el)
  local cls, meta = find_callout(el)
  if not cls then return nil end

  local appearance = normalize_appearance(el.attributes.appearance)
  local collapse = el.attributes.collapse
  local has_collapse = collapse ~= nil
  collapse = normalize_bool(collapse)

  local id = el.identifier
  local has_id = id and id ~= ""

  local user_title = el.attributes.title
  local has_title = user_title and user_title ~= ""

  -- title logic (CRITICAL for crossref)
  local title_inlines = {}

  if not has_id and not has_title then
    -- plain callout
    title_inlines = pandoc.Inlines({ pandoc.Str(meta.title_key) })

  elseif has_title and not has_id then
    -- only user title
    title_inlines = pandoc.Inlines(user_title)

  elseif has_id and not has_title then
    -- crossref only
    title_inlines = pandoc.Inlines({ pandoc.Str(meta.crossref_key) })

  elseif has_id and has_title then
    -- BOTH
    title_inlines = pandoc.Inlines({
      pandoc.Str(meta.crossref_key .. ": "),
      pandoc.Str(user_title)
    })
  end

  -- CLASSES
  local classes = {
    "callout",
    "callout-style-" .. appearance,
    "callout-note", -- keep base
    cls
  }

  if has_collapse then
    if collapse then
      table.insert(classes, "collapse")
      table.insert(classes, "collapsed")
    else
      table.insert(classes, "collapse")
    end
  end

  -- HEADER
  local header = pandoc.Div({}, {class = "callout-header"})

  local title_div = pandoc.Div({}, {class = "callout-title"})

  if appearance ~= "minimal" then
    local icon = pandoc.Span({}, {class = "callout-icon"})
    icon.content = { pandoc.RawInline("html", "<i class='bi bi-" .. meta.icon .. "'></i>") }
    table.insert(title_div.content, icon)
  end

  table.insert(title_div.content, pandoc.Span(title_inlines))

  header.content = { title_div }

  -- BODY
  local body = pandoc.Div(el.content, {class = "callout-body"})

  local content = { header, body }

  -- FINAL DIV (IMPORTANT: keeps identifier for crossref)
  return pandoc.Div(content, {
    id = id,
    class = table.concat(classes, " ")
  })
end

