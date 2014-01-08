
import Widget from require "lapis.html"

class LuminaryConsoleTool extends Widget
  @include "luminary.views.util"

  body_content: =>
    div id: "editor", ->
      div class: "editor_top", ->
        div class: "buttons_top", ->
          button class: "run_btn", "Run (Ctrl+Enter)"
          text " "
          button class: "clear_btn", "Clear (Ctrl+K)"

        div ->
          textarea!

        div class: "status", "Ready"

      div class: "log"
      div class: "footer", "lapis_console 0.0.1"

