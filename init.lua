local config = require("lapis.config").get()
local render_html
do
  local _obj_0 = require("lapis.html")
  render_html = _obj_0.render_html
end
local insert, concat
do
  local _obj_0 = table
  insert, concat = _obj_0.insert, _obj_0.concat
end
local empty_routes = {
  path = "",
  name = "",
  __base = { }
}
local empty_render
empty_render = function(...)
  return ""
end
local empty_capture
empty_capture = function(...) end
if config._name == "development" and config.luminary and config.luminary.enable_console then
  return {
    routes = require("luminary.apps.main"),
    capture_queries = function(self)
      self._luminary = {
        queries = { }
      }
      local db = require("lapis.db")
      local old_logger = db.get_logger()
      return db.set_logger({
        query = function(q)
          insert(self._luminary.queries, q)
          if old_logger then
            return old_logger.query(q)
          end
        end
      })
    end,
    render_toolbar = function(lapis_env)
      local w = require("luminary.views.toolbar")
      w:include_helper(lapis_env)
      return render_html(function()
        return raw(w:render_to_string())
      end)
    end
  }
else
  return {
    routes = empty_routes,
    capture_queries = empty_capture,
    render_toolbar = empty_render
  }
end
