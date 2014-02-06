
config = require"lapis.config".get!

import render_html from require "lapis.html"
import insert, concat from table

-- This is totally a hack on how Moonscript and lapis.Application handles @include(other_app)
empty_routes =
  path: ""
  name: ""
  __base: {}

empty_render = (...) ->
  return ""

empty_capture = (...) ->
  return

if config._name == "development"
  {
    _VERSION: "alpha"

    routes: if config.luminary and config.luminary.enable_console == false
        empty_routes
      else
        require "luminary.apps.main"


    capture_queries: =>
      @_luminary = {
        queries: {}
      }

      db = require "lapis.db"
      old_logger = db.get_logger!

      db.set_logger {
        query: (q) ->
          insert @_luminary.queries, q
          old_logger.query q if old_logger
      }

    render_toolbar: (lapis_env) ->
      w = require "luminary.views.toolbar"
      w\include_helper lapis_env
  
      render_html ->
        raw w\render_to_string!
  }
else
  {
    routes: empty_routes
    capture_queries: empty_capture
    render_toolbar: empty_render
  }

