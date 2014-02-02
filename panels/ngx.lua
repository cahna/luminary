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
local ngx_vars = {
  "nginx_version",
  "uri",
  "host",
  "hostname",
  "document_root",
  "document_uri",
  "remote_addr",
  "remote_port",
  "remote_user",
  "server_addr",
  "server_name",
  "server_port",
  "server_protocol",
  "request_uri",
  "request_filename",
  "request_body",
  "request_body_file",
  "request_completion",
  "request_method",
  "scheme",
  "http_user_agent",
  "http_referer",
  "args",
  "content_length",
  "content_type",
  "cookie_test",
  "headers_in",
  "headers_out",
  "is_args",
  "limit_rate",
  "query_string",
  "body_bytes_sent"
}
local ngx_constants = {
  status = {
    "HTTP_OK",
    "HTTP_CREATED",
    "HTTP_SPECIAL_RESPONSE",
    "HTTP_MOVED_PERMANENTLY",
    "HTTP_MOVED_TEMPORARILY",
    "HTTP_SEE_OTHER",
    "HTTP_NOT_MODIFIED",
    "HTTP_BAD_REQUEST",
    "HTTP_UNAUTHORIZED",
    "HTTP_FORBIDDEN",
    "HTTP_NOT_FOUND",
    "HTTP_NOT_ALLOWED",
    "HTTP_GONE",
    "HTTP_INTERNAL_SERVER_ERROR",
    "HTTP_METHOD_NOT_IMPLEMENTED",
    "HTTP_SERVICE_UNAVAILABLE",
    "HTTP_GATEWAY_TIMEOUT"
  },
  method = {
    "HTTP_GET",
    "HTTP_HEAD",
    "HTTP_PUT",
    "HTTP_POST",
    "HTTP_DELETE",
    "HTTP_OPTIONS",
    "HTTP_MKCOL",
    "HTTP_COPY",
    "HTTP_MOVE",
    "HTTP_PROPFIND",
    "HTTP_PROPPATCH",
    "HTTP_LOCK",
    "HTTP_UNLOCK",
    "HTTP_PATCH",
    "HTTP_TRACE"
  },
  log = {
    "STDERR",
    "EMERG",
    "ALERT",
    "CRIT",
    "ERR",
    "WARN",
    "NOTICE",
    "INFO",
    "DEBUG"
  },
  core = {
    "OK",
    "ERROR",
    "AGAIN",
    "DONE",
    "DECLINED",
    "null"
  }
}
local cmp_tuple_vals
cmp_tuple_vals = function(a, b)
  local v1, v2 = a[2], b[2]
  local success, val = pcall(tonumber, v1)
  if not success or val == nil then
    v1 = 0
  else
    v1 = val
  end
  success, val = pcall(tonumber, v2)
  if not success or val == nil then
    v2 = 0
  else
    v2 = val
  end
  return v1 < v2
end
local NgxInfoPanel
do
  local _parent_0 = require("luminary.panels.base")
  local _base_0 = {
    content = function(self)
      local ngx = require("ngx")
      local ngx_var
      do
        local _tbl_0 = { }
        for _index_0 = 1, #ngx_vars do
          local v = ngx_vars[_index_0]
          _tbl_0[v] = tostring(ngx.var[v] or "")
        end
        ngx_var = _tbl_0
      end
      h1(function()
        return text("Server Configuration")
      end)
      self:tuple_table({
        {
          "Server address",
          ngx_var.server_addr
        },
        {
          "Server port",
          ngx_var.server_port
        },
        {
          "Nginx version",
          tostring(ngx_var.nginx_version) .. " (" .. tostring(ngx.config.nginx_version) .. ")"
        },
        {
          "Debug build",
          ngx.config.debug
        },
        {
          "Prefix path",
          ngx.config.prefix()
        }
      })
      if jit then
        h1(function()
          return text("LuaJIT")
        end)
        self:table_contents((function()
          local _tbl_0 = { }
          for k, v in pairs(jit) do
            if type(v) == "string" or type(v) == "number" then
              _tbl_0[k] = v
            end
          end
          return _tbl_0
        end)())
      end
      h1(function()
        return text("ngx.var")
      end)
      self:table_contents(ngx_var)
      h1(function()
        return text("Lua")
      end)
      local loaded_modules
      do
        local _accum_0 = { }
        local _len_0 = 1
        for k, _ in pairs(package.loaded) do
          _accum_0[_len_0] = label_wrap(k)
          _len_0 = _len_0 + 1
        end
        loaded_modules = _accum_0
      end
      local ppath = concat((function()
        local _accum_0 = { }
        local _len_0 = 1
        for p in package.path:gmatch("[^;]+") do
          _accum_0[_len_0] = float_wrap(p .. ";")
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)())
      local pcpath = concat((function()
        local _accum_0 = { }
        local _len_0 = 1
        for p in package.cpath:gmatch("[^;]+") do
          _accum_0[_len_0] = float_wrap(p .. ";")
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)())
      self:tuple_table({
        {
          "Nginx Lua version",
          tostring(_VERSION) .. " (" .. tostring(ngx.config.ngx_lua_version) .. ")"
        },
        {
          "package.path",
          ppath
        },
        {
          "package.cpath",
          pcpath
        },
        {
          "package.loaded",
          concat(loaded_modules)
        }
      })
      h1(function()
        return text("Nginx constants")
      end)
      for name, values in pairs(ngx_constants) do
        h3(function()
          return text(name)
        end)
        local ngx_cvals
        do
          local _accum_0 = { }
          local _len_0 = 1
          for _index_0 = 1, #values do
            local key = values[_index_0]
            _accum_0[_len_0] = {
              "ngx." .. tostring(key),
              tostring(ngx[key])
            }
            _len_0 = _len_0 + 1
          end
          ngx_cvals = _accum_0
        end
        sort(ngx_cvals, cmp_tuple_vals)
        self:tuple_table(ngx_cvals)
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
    __name = "NgxInfoPanel",
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
  self.title = "Ngx_openresty"
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  NgxInfoPanel = _class_0
  return _class_0
end
