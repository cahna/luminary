
import Widget from require "lapis.html"

class LuminaryConsoleTool extends Widget
  script: (name) =>
    script type: "text/javascript", ->
      raw require "lapis.console.assets.#{name}"

  style: (name) =>
    style type: "text/css", ->
      raw require "lapis.console.assets.#{name}"

  content: =>
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

    -- Include scripts
    @script ("lib/jquery_min.js")\gsub "[%/%.]", "_"
    @script "lib/codemirror.js"\gsub "[%/%.]", "_"
    @script "mode_moonscript.js"\gsub "[%/%.]", "_"
    @script "mode_lua_js"\gsub "[%/%.]", "_"
    script type: "text/javascript", src: "/static/luminary/console/js/main.js"

    -- Include styles 
    @style "lib_codemirror_css"
    @style "theme_moon_css"
    link rel: "stylesheet", href: "/static/luminary/console/style/main.css"

    script type: "text/javascript", ->
      raw [[_editor = new Lapis.Editor("#editor");]]

