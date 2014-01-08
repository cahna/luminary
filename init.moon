
import render_html from require "lapis.html"

app = require "luminary.apps.main"

widget = (lapis_env) ->
  w = require "luminary.views.toolbar"

  w\include_helper lapis_env

  ->
    render_html ->
      raw w\render_to_string!

{:app, :widget}

