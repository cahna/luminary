local insert, concat, sort
do
  local _obj_0 = table
  insert, concat, sort = _obj_0.insert, _obj_0.concat, _obj_0.sort
end
local RouterPanel
do
  local _parent_0 = require("luminary.panels.base")
  local _base_0 = {
    content = function(self)
      h1(function()
        return text("Routes")
      end)
      local tab_classes = {
        "table",
        "table-striped"
      }
      return element("table", {
        class = concat(tab_classes, " ")
      }, function()
        tr(function()
          th(function()
            return text("#")
          end)
          th(function()
            return text("Path")
          end)
          th(function()
            return text("Name")
          end)
          return th(function()
            return text("Action")
          end)
        end)
        local default_route, routes
        do
          local _obj_0 = self.app.router
          default_route, routes = _obj_0.default_route, _obj_0.routes
        end
        sort(routes, function(t1, t2)
          return t1[3] < t2[3]
        end)
        local n = 0
        for _index_0 = 1, #routes do
          local _des_0 = routes[_index_0]
          local r_path, r_action, r_name
          r_path, r_action, r_name = _des_0[1], _des_0[2], _des_0[3]
          n = n + 1
          local row_classes = { }
          if r_action == default_route then
            insert(row_classes, "success")
          else
            if r_name:match("luminary") then
              insert(row_classes, "warning")
            end
          end
          tr({
            class = concat(row_classes)
          }, function()
            td(function()
              return text(n)
            end)
            td(function()
              return text(r_path)
            end)
            td(function()
              return text(r_name)
            end)
            return td(function()
              return text(tostring(r_action))
            end)
          end)
        end
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
    __name = "RouterPanel",
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
  self.title = "Router"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  RouterPanel = _class_0
  return _class_0
end
