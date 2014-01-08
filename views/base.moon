
import Widget from require "lapis.html"

class LuminaryLayout extends Widget
  @include "luminary.views.util"

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

