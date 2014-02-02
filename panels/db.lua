local render_html
do
  local _obj_0 = require("lapis.html")
  render_html = _obj_0.render_html
end
local label_wrap, float_wrap
do
  local _obj_0 = require("luminary.util")
  label_wrap, float_wrap = _obj_0.label_wrap, _obj_0.float_wrap
end
local sort, concat
do
  local _obj_0 = table
  sort, concat = _obj_0.sort, _obj_0.concat
end
local format_query
format_query = function(q)
  return render_html(function()
    return span({
      style = "font-family: Monaco, Menlo, Consolas, 'Courier New', monospace;"
    }, function()
      span({
        style = "color:magenta;font-weight:bold;"
      }, function()
        return text("SQL: ")
      end)
      return span({
        style = "color:navy;"
      }, function()
        return raw(q)
      end)
    end)
  end)
end
local DatabasePanel
do
  local _parent_0 = require("luminary.panels.base")
  local _base_0 = {
    content = function(self)
      h1(function()
        return text("Queries")
      end)
      if self._luminary then
        if self._luminary.queries then
          local n = 0
          for i, q in ipairs(self._luminary.queries) do
            self._luminary.queries[i] = format_query(q)
            n = n + 1
          end
          if n > 0 then
            return self:table_contents(self._luminary.queries)
          else
            return pre(function()
              return text("No queries captured")
            end)
          end
        else
          return pre(function()
            return text("Query capture error!")
          end)
        end
      else
        return pre(function()
          return "Unable to capture queries. Did you add `luminary.capture_queries!` to your @before_filter? Check your configuration."
        end)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "DatabasePanel",
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
  self.title = "Queries"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  DatabasePanel = _class_0
  return _class_0
end
