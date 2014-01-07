
import Widget from require "lapis.html"

class LuminaryBase extends Widget
  include_script: (name) =>
    script type: "text/javascript", ->
      raw require "luminary.assets.#{name}_js"

  include_style: (name) =>
    style type: "text/css", ->
      raw require "luminary.assets.#{name}_css"

  content: =>
    @include_style "luminary"

    -- Toggle button
    div id: "luminary-activate", ->
      div id: "luminary-button", class: "btn btn-warning", ->
        text "</>"

    -- Main overlay div
    div id: "luminary", class: "hide", ->
      @content_for "inner"

    @include_script "luminary"

--  console_content: =>
--    @console_script "lib_codemirror_js"
--    @console_script "mode_moonscript_js"
--    @console_script "mode_lua_js"
--    @console_script "main_js"
--
--    @console_style "lib_codemirror_css"
--    @console_style "theme_moon_css"
--    @console_style "main_css"
--
--
--  content2: =>
--
--
--
--    div id: "editor", ->
--      div class: "editor_top", ->
--        div class: "buttons_top", ->
--          button class: "run_btn", "Run (Ctrl+Enter)"
--          text " "
--          button class: "clear_btn", "Clear (Ctrl+K)"
--
--        div ->
--          textarea!
--
--        div class: "status", "Ready"
--
--      div class: "log"
--      div class: "footer", "lapis_console 0.0.1"
----    script type: "text/javascript", ->
----      raw [[$(document).ready(function(){ _editor = new Lapis.Editor('#editor'); });]]
