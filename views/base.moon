
import Widget from require "lapis.html"

class LuminaryLayout extends Widget
  include_script: (name, path = "assets") =>
    script type: "text/javascript", ->
      raw require "luminary.#{path}.#{name}_js"

  include_style: (name, path = "assets") =>
    style type: "text/css", ->
      raw require "luminary.#{path}.#{name}_css"

  inner_content: =>
    raw "Overload me"

  content: =>
    @include_style "luminary"

    -- Toggle button
    div id: "luminary-activate", ->
      div id: "luminary-button", class: "btn btn-warning", ->
        text "</>"

    -- Main overlay div
    div id: "luminary", class: "hide", ->
      @inner_content!

    @JsHelper\add_on_ready require "luminary.assets.luminary_js"

