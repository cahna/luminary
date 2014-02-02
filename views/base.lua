local Widget
do
  local _obj_0 = require("lapis.html")
  Widget = _obj_0.Widget
end
local LuminaryLayout
do
  local _parent_0 = Widget
  local _base_0 = {
    inner_content = function(self)
      return raw("Overload me")
    end,
    content = function(self)
      style({
        type = "text/css"
      }, function()
        return raw(require("luminary.assets.luminary_css"))
      end)
      div({
        id = "luminary-activate"
      }, function()
        return div({
          id = "luminary-button",
          class = "btn btn-warning"
        }, function()
          return text("</>")
        end)
      end)
      div({
        id = "luminary",
        class = "hide"
      }, function()
        return self:inner_content()
      end)
      return script({
        type = "text/javascript"
      }, function()
        return raw(require("luminary.assets.luminary_js"))
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
    __name = "LuminaryLayout",
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
  LuminaryLayout = _class_0
  return _class_0
end
