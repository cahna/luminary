local Widget
do
  local _obj_0 = require("lapis.html")
  Widget = _obj_0.Widget
end
local PanelBase
do
  local _parent_0 = Widget
  local _base_0 = {
    content = function(self)
      return h1("Extend this class to create your own Luminary Panels!")
    end,
    safe_h1 = function(self, h)
      return h1(function()
        local _t = type(h)
        if _t == "string" then
          return text(tostring(h) .. ":")
        else
          return text(tostring(h) .. " (" .. tostring(_t) .. ")")
        end
      end)
    end,
    table_contents = function(self, d)
      local _t = type(d)
      if _t == "table" then
        return element("table", {
          class = "table table-bordered table-striped",
          style = "width:100%;"
        }, function()
          for _element, _value in pairs(d) do
            tr(function()
              td({
                style = "width: 20%; font-weight: bold;"
              }, function()
                return raw(tostring(_element))
              end)
              return td({
                style = "width: 80%;"
              }, function()
                if type(_value) == "table" then
                  return self:table_contents(_value)
                else
                  return raw(tostring(_value))
                end
              end)
            end)
          end
        end)
      elseif _t == "string" then
        return div({
          class = "luminary-data"
        }, function()
          return text(d)
        end)
      else
        return pre(tostring(d))
      end
    end,
    tuple_table = function(self, t)
      if not (type(t) == "table") then
        return 
      end
      return element("table", {
        class = "table table-bordered table-striped",
        style = "width:100%;"
      }, function()
        for _index_0 = 1, #t do
          local _des_0 = t[_index_0]
          local directive, value
          directive, value = _des_0[1], _des_0[2]
          tr(function()
            td({
              style = "width: 20%; font-weight: bold;"
            }, function()
              return raw(tostring(directive))
            end)
            return td({
              style = "width: 80%;"
            }, function()
              return raw(tostring(value))
            end)
          end)
        end
      end)
    end,
    render_section = function(self, t, d)
      self:safe_h1(t)
      return self:table_contents(d)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "PanelBase",
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
  self.title = "Panel Title"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  PanelBase = _class_0
  return _class_0
end
