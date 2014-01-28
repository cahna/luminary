
import label_wrap, float_wrap from require "luminary.panels.util"
import concat from table

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


class NgxInfoPanel extends require "luminary.panels.base"
  title: "Nginx"

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

