-- custom-callouts.lua
-- Quarto >= 1.3
-- Native implementation via quarto.Callout()

local CALLS = {
  ["callout-myth"] = {
    key = "mth",
    icon = "exclamation-diamond"
  },
  ["callout-history"] = {
    key = "hst",
    icon = "book"
  },
  ["callout-person"] = {
    key = "prs",
    icon = "person-circle"
  },
  ["callout-dataset"] = {
    key = "dts",
    icon = "database"
  }
}

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

function Div(el)
  local cls, meta = find_callout(el)
  if not cls then return nil end

  local id = el.identifier
  if not id or id == "" then
    -- без id → НЕ float → НЕ участвует в crossref
    return nil
  end

  -- определяем float key по id (mth-*, hst-*, ...)
  if not id:match("^" .. meta.key .. "%-") then
    -- защита от несовпадения id и типа
    return nil
  end

  local appearance = normalize_appearance(el.attributes.appearance)

  local collapse_raw = el.attributes.collapse
  local has_collapse = collapse_raw ~= nil
  local collapse = normalize_bool(collapse_raw)

  local user_title = el.attributes.title

  -- ВАЖНО: caption для Quarto (нативный crossref)
  local caption = {}

  if user_title then
    caption = pandoc.Inlines(user_title)
  else
    caption = pandoc.Inlines({})
  end

  -- превращаем в float
  el.attributes["quarto-float"] = meta.key
  el.attributes["quarto-caption"] = pandoc.utils.stringify(caption)

  -- классы
  local classes = {
    "callout",
    "callout-note",
    "callout-style-" .. appearance,
    cls
  }

  if has_collapse then
    table.insert(classes, "collapse")
    if collapse then
      table.insert(classes, "collapsed")
    end
  end

  -- HEADER (визуальный, не влияет на crossref!)
  local header = pandoc.Div({}, {class = "callout-header"})
  local title_div = pandoc.Div({}, {class = "callout-title"})

  if appearance ~= "minimal" then
    table.insert(title_div.content,
      pandoc.RawInline("html",
        "<i class='bi bi-" .. meta.icon .. "'></i>"
      )
    )
  end

  -- placeholder (Quarto сам вставит caption + номер!)
  table.insert(title_div.content, pandoc.Str(""))

  header.content = { title_div }

  local body = pandoc.Div(el.content, {class = "callout-body"})

  return pandoc.Div(
    { header, body },
    {
      id = id,
      class = table.concat(classes, " "),
      attributes = el.attributes
    }
  )
end
