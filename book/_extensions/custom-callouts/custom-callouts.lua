-- custom-callouts.lua
-- Quarto >= 1.3
-- Native implementation via quarto.Callout()

local CALLS = {
  ["callout-history"] = {
    type = "history",
    crossref_prefix = "hst",
    title_key = "crossref-hst-title"
  },

  ["callout-person"] = {
    type = "person",
    crossref_prefix = "prs",
    title_key = "crossref-prs-title"
  },

  ["callout-dataset"] = {
    type = "dataset",
    crossref_prefix = "dts",
    title_key = "crossref-dts-title"
  },

  ["callout-myth"] = {
    type = "myth",
    crossref_prefix = "mth",
    title_key = "crossref-mth-title"
  }
}

local function has_class(el, class)
  if not el.classes then
    return false
  end

  for _, c in ipairs(el.classes) do
    if c == class then
      return true
    end
  end

  return false
end

local function first_matching_callout(el)
  for class, meta in pairs(CALLS) do
    if has_class(el, class) then
      return class, meta
    end
  end

  return nil, nil
end

local function normalize_appearance(value)
  local allowed = {
    ["default"] = true,
    ["simple"] = true,
    ["minimal"] = true
  }

  if value and allowed[value] then
    return value
  end

  return "default"
end

local function normalize_collapse(value)
  if value == true or value == "true" then
    return true
  end

  return false
end

local function get_default_title(meta)
  -- Quarto automatically resolves language keys when title=nil is not set.
  -- Here we provide explicit fallback for robustness.
  local defaults = {
    --["crossref-hst-title"] = "История",
    --["crossref-prs-title"] = "Персона",
    --["crossref-dts-title"] = "Датасет",
    --["crossref-mth-title"] = "Миф"
  }

  return defaults[meta.title_key] or "Callout"
end

function Div(el)
  local matched_class, meta = first_matching_callout(el)

  if not matched_class then
    return nil
  end

  local appearance = normalize_appearance(el.attributes.appearance)
  local collapse = normalize_collapse(el.attributes.collapse)

  local title = el.attributes.title
  if not title or title == "" then
    title = get_default_title(meta)
  end

  local identifier = el.identifier

  local remaining_classes = {}
  for _, cls in ipairs(el.classes) do
    if cls ~= matched_class then
      table.insert(remaining_classes, cls)
    end
  end

  table.insert(remaining_classes, matched_class)

  local callout = quarto.Callout({
    type = "note",
    title = pandoc.Inlines(title),
    content = el.content,
    appearance = appearance,
    collapse = collapse,
    icon = false,
    identifier = identifier,
    classes = remaining_classes,
    attributes = el.attributes
  })

  return callout
end
