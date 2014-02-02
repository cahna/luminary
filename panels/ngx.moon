
import label_wrap, float_wrap from require "luminary.util"
import sort, concat from table

-- Available ngx variables
ngx_vars = {
  "nginx_version"
  "uri"
  "host"
  "hostname"
  "document_root"
  "document_uri"
  "remote_addr"
  "remote_port"
  "remote_user"
  "server_addr"
  "server_name"
  "server_port"
  "server_protocol"
  "request_uri"
  "request_filename"
  "request_body"
  "request_body_file"
  "request_completion"
  "request_method"
  "scheme"
  "http_user_agent"
  "http_referer"
  "args"
  "content_length"
  "content_type"
  "cookie_test"
  "headers_in"
  "headers_out"
  "is_args"
  "limit_rate"
  "query_string"
  "body_bytes_sent"
}

ngx_constants = {
  status: {
    "HTTP_OK"
    "HTTP_CREATED"
    "HTTP_SPECIAL_RESPONSE"
    "HTTP_MOVED_PERMANENTLY"
    "HTTP_MOVED_TEMPORARILY"
    "HTTP_SEE_OTHER"
    "HTTP_NOT_MODIFIED"
    "HTTP_BAD_REQUEST"
    "HTTP_UNAUTHORIZED"
    "HTTP_FORBIDDEN"
    "HTTP_NOT_FOUND"
    "HTTP_NOT_ALLOWED"
    "HTTP_GONE"
    "HTTP_INTERNAL_SERVER_ERROR"
    "HTTP_METHOD_NOT_IMPLEMENTED"
    "HTTP_SERVICE_UNAVAILABLE"
    "HTTP_GATEWAY_TIMEOUT"
  }
  method: {
    "HTTP_GET"
    "HTTP_HEAD"
    "HTTP_PUT"
    "HTTP_POST"
    "HTTP_DELETE"
    "HTTP_OPTIONS"
    "HTTP_MKCOL"
    "HTTP_COPY"
    "HTTP_MOVE"
    "HTTP_PROPFIND"
    "HTTP_PROPPATCH"
    "HTTP_LOCK"
    "HTTP_UNLOCK"
    "HTTP_PATCH"
    "HTTP_TRACE"
  }
  log: {
    "STDERR"
    "EMERG"
    "ALERT"
    "CRIT"
    "ERR"
    "WARN"
    "NOTICE"
    "INFO"
    "DEBUG"
  }
  core: {"OK", "ERROR", "AGAIN", "DONE", "DECLINED", "null"}
}

-- Nginx constants are returned as strings. This compare function handles sane sorting
-- of a table of tuples such that each tuple is of the form {dontcare, string} where 
-- the string value is a string-representation of a number. Anything that can't sanely
-- be converted to a number through lua's tonumber(...) is given a value of 0 so its
-- element is pushed to the bottom of the tuple list upon sorting.
cmp_tuple_vals = (a,b) ->
  v1,v2 = a[2], b[2]

  success,val = pcall(tonumber, v1)
  if not success or val == nil
    v1 = 0
  else
    v1 = val
  
  success,val = pcall(tonumber, v2)
  if not success or val == nil
    v2 = 0
  else
    v2 = val

  v1 < v2

class NgxInfoPanel extends require "luminary.panels.base"
  @title = "Ngx_openresty"

  content: =>
    ngx = require "ngx"

    -- Copy ngx vars to local scope to avoid potential memory leaks with openresty requests
    ngx_var = { v, tostring(ngx.var[v] or "") for v in *ngx_vars }

    -- Nginx server configuration and build info
    h1 ->
      text "Server Configuration"

    @tuple_table {
      { "Server address", ngx_var.server_addr }
      { "Server port",    ngx_var.server_port }
      { "Nginx version",  "#{ngx_var.nginx_version} (#{ngx.config.nginx_version})" }
      { "Debug build",    ngx.config.debug }
      { "Prefix path",    ngx.config.prefix! }
    }

    -- Detect luajit
    if jit
      h1 ->
        text "LuaJIT"

      @table_contents {k,v for k,v in pairs jit when type(v) == "string" or type(v) == "number"}

    -- Nginx variables accessible to lua
    h1 ->
      text "ngx.var"

    @table_contents ngx_var

    -- Lua environment
    h1 ->
      text "Lua"

    -- These tables/paths can be large. Lazily floating them to simply avoid excessive screen overflow
    loaded_modules = [label_wrap(k) for k,_ in pairs package.loaded]
    ppath = concat [float_wrap(p..";") for p in package.path\gmatch("[^;]+")]
    pcpath = concat [float_wrap(p..";") for p in package.cpath\gmatch("[^;]+")]

    @tuple_table {
      { "Nginx Lua version", "#{_VERSION} (#{ngx.config.ngx_lua_version})" }
      { "package.path",      ppath }
      { "package.cpath",     pcpath }
      { "package.loaded",    concat loaded_modules }
    }

    h1 ->
      text "Nginx constants"

    for name, values in pairs ngx_constants
      h3 ->
        text name

      ngx_cvals = [ {"ngx.#{key}", tostring ngx[key]} for key in *values ]
      
      sort ngx_cvals, cmp_tuple_vals
      @tuple_table ngx_cvals

