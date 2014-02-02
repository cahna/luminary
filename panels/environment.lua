local config = require("lapis.config").get()
local label_wrap, float_wrap
do
  local _obj_0 = require("luminary.panels.util")
  label_wrap, float_wrap = _obj_0.label_wrap, _obj_0.float_wrap
end
local sort, concat
do
  local _obj_0 = table
  sort, concat = _obj_0.sort, _obj_0.concat
end
local LapisEnvironmentPanel
do
  local _parent_0 = require("luminary.panels.base")
  local _base_0 = {
    content = function(self)
      h1(function()
        return text("Lapis Environment Configuration")
      end)
      return self:table_contents(config)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LapisEnvironmentPanel",
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
  self.title = "Lapis Environment"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  LapisEnvironmentPanel = _class_0
  return _class_0
end
