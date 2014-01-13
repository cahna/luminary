
import Widget from require "lapis.html"

class LuminaryLayout extends Widget

  inner_content: =>
    raw "Overload me"

  content: =>
    link rel: "stylesheet", type: "text/css", href: "/static/luminary/style/luminary.css"

    -- Toggle button
    div id: "luminary-activate", ->
      div id: "luminary-button", class: "btn btn-warning", ->
        text "</>"

    -- Main overlay div
    div id: "luminary", class: "hide", ->
      @inner_content!

    script type: "text/javascript", ->
      raw require "luminary.assets.luminary_js"

