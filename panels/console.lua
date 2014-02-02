local Widget
do
  local _obj_0 = require("lapis.html")
  Widget = _obj_0.Widget
end
local LapisConsolePanel
do
  local _parent_0 = Widget
  local _base_0 = {
    script = function(self, name, base)
      if base == nil then
        base = "lapis.console.assets"
      end
      return script({
        type = "text/javascript"
      }, function()
        return raw(require(tostring(base) .. "." .. tostring(name)))
      end)
    end,
    style = function(self, name, base)
      if base == nil then
        base = "lapis.console.assets"
      end
      return style({
        type = "text/css"
      }, function()
        return raw(require(tostring(base) .. "." .. tostring(name)))
      end)
    end,
    content = function(self)
      self:style("lib_codemirror_css")
      self:style("theme_moon_css")
      self:style("main_css", "luminary.console.assets")
      div({
        id = "editor"
      }, function()
        div({
          class = "editor_top"
        }, function()
          div({
            class = "buttons_top"
          }, function()
            button({
              class = "run_btn"
            }, "Run (Ctrl+Enter)")
            text(" ")
            return button({
              class = "clear_btn"
            }, "Clear (Ctrl+K)")
          end)
          div(function()
            return textarea()
          end)
          return div({
            class = "status"
          }, "Ready")
        end)
        div({
          class = "log"
        })
        return div({
          class = "footer"
        }, "lapis_console 0.0.1")
      end)
      self:script("lib_codemirror_js")
      self:script("mode_moonscript_js")
      self:script("mode_lua_js")
      self:script("main_js", "luminary.console.assets")
      return script({
        type = "text/javascript"
      }, function()
        return raw("_editor = new Lapis.Editor('#editor');")
      end)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LapisConsolePanel",
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
  local self = _class_0
  self.title = "Lapis Console"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  LapisConsolePanel = _class_0
  return _class_0
end
