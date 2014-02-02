local slugify
do
  local _obj_0 = require("lapis.util")
  slugify = _obj_0.slugify
end
local insert, concat
do
  local _obj_0 = table
  insert, concat = _obj_0.insert, _obj_0.concat
end
local defaults = {
  "luminary.panels.request",
  "luminary.panels.db",
  "luminary.panels.ngx",
  "luminary.panels.router",
  "luminary.panels.environment",
  "luminary.panels.console"
}
local LuminaryIndex
do
  local _parent_0 = require("luminary.views.base")
  local _base_0 = {
    load_panel = function(self, path)
      local panel = require(path)
      panel:include_helper(self)
      return panel
    end,
    load_all = function(self, names)
      local conf = { }
      for i, name in ipairs(names) do
        local panel = self:load_panel(name)
        local id = "luminary-" .. tostring(i) .. "-" .. tostring(slugify(panel.title or panel.__name or 'DefaultPanel'))
        insert(conf, {
          id,
          panel.title,
          panel
        })
      end
      return conf
    end,
    render_nav = function(self, conf)
      return div({
        id = "luminary-nav",
        class = "pull-right"
      }, function()
        return ul({
          class = "nav nav-pills nav-stacked"
        }, function()
          li({
            class = "luminary-close"
          }, function()
            return a({
              href = "#"
            }, function()
              return text("Close Luminary >>")
            end)
          end)
          for n, c in ipairs(conf) do
            local id, title = c[1], c[2]
            li({
              class = (n == 1 and "active" or nil)
            }, function()
              return a({
                href = "#" .. tostring(id),
                ["data-toggle"] = "tab"
              }, function()
                return text(tostring(title))
              end)
            end)
          end
        end)
      end)
    end,
    render_panels = function(self, panels)
      return div({
        id = "luminary-body",
        class = "col-md-10"
      }, function()
        return div({
          class = "tab-content"
        }, function()
          for i, _des_0 in ipairs(panels) do
            local id, title, panel
            id, title, panel = _des_0[1], _des_0[2], _des_0[3]
            div({
              id = tostring(id),
              class = "tab-pane " .. tostring(i == 1 and 'active')
            }, function()
              return raw(panel:render_to_string())
            end)
          end
        end)
      end)
    end,
    inner_content = function(self)
      local panels = self:load_all(defaults)
      self:render_nav(panels)
      return self:render_panels(panels)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LuminaryIndex",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  LuminaryIndex = _class_0
  return _class_0
end
