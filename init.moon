
import render_html from require "lapis.html"

routes = require "luminary.apps.main"

render_toolbar = (lapis_env) ->
  w = require "luminary.views.toolbar"
  w\include_helper lapis_env

  render_html ->
    raw w\render_to_string!

{:routes, :render_toolbar}

