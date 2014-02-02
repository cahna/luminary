local Application, respond_to, capture_errors_json, assert_error, yield_error
do
  local _obj_0 = require("lapis.application")
  Application, respond_to, capture_errors_json, assert_error, yield_error = _obj_0.Application, _obj_0.respond_to, _obj_0.capture_errors_json, _obj_0.assert_error, _obj_0.yield_error
end
local assert_valid
do
  local _obj_0 = require("lapis.validate")
  assert_valid = _obj_0.assert_valid
end
local run, make
do
  local _obj_0 = require("lapis.console")
  run, make = _obj_0.run, _obj_0.make
end
local LuminaryRoutes
do
  local _parent_0 = Application
  local _base_0 = {
    [{
      console = "/console"
    }] = respond_to({
      GET = make(),
      POST = capture_errors_json(function(self)
        self.params.lang = self.params.lang or "moonscript"
        self.params.code = self.params.code or ""
        assert_valid(self.params, {
          {
            "lang",
            one_of = {
              "lua",
              "moonscript"
            }
          }
        })
        if self.params.lang == "moonscript" then
          local moonscript = require("moonscript.base")
          local fn, err = moonscript.loadstring(self.params.code)
          if err then
            return {
              json = {
                error = err
              }
            }
          else
            local lines, queries = run(self, fn)
            if lines then
              return {
                json = {
                  lines = lines,
                  queries = queries
                }
              }
            else
              return {
                json = {
                  error = queries
                }
              }
            end
          end
        end
      end)
    })
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LuminaryRoutes",
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
  self.path = "/luminary"
  self.name = "luminary_"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  LuminaryRoutes = _class_0
  return _class_0
end
