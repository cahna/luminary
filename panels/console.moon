
import Widget from require "lapis.html"

class LapisConsolePanel extends Widget
  @title = "Lapis Console"

  script: (name, base = "lapis.console.assets") =>
    script type: "text/javascript", ->
      raw require "#{base}.#{name}"

  style: (name, base = "lapis.console.assets") =>
    style type: "text/css", ->
      raw require "#{base}.#{name}"

  content: =>
    -- Include styles 
    @style "lib_codemirror_css"
    @style "theme_moon_css"
    @style "main_css", "luminary.console.assets"

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
    --@script "lib_jquery_min_js"
    @script "lib_codemirror_js"
    @script "mode_moonscript_js"
    @script "mode_lua_js"
    @script "main_js", "luminary.console.assets"

    script type: "text/javascript", ->
      raw "_editor = new Lapis.Editor('#editor');"

