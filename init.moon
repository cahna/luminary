
config = require"lapis.config".get!

import render_html from require "lapis.html"

-- This is totally a hack on how and lapis.Application handles @include(other_app)
empty_routes =
  path: ""
  name: ""
  __base: {}

empty_render = (...) ->
  return ""

if config._name == "development" and config.luminary and config.luminary.enable_console
  {
    routes: require "luminary.apps.main"

    render_toolbar: (lapis_env) ->
      w = require "luminary.views.toolbar"
      w\include_helper lapis_env
  
      render_html ->
        raw w\render_to_string!
  }
else
  {
    routes: empty_routes
    render_toolbar: empty_render
  }

