
import Widget from require "lapis.html"
import write from require "pl.pretty"

class LuminaryIndex extends require "luminary.views.base"
  inner_content: =>
    div id: "luminary-nav", class: "pull-right", ->
      ul class: "nav nav-pills nav-stacked", ->
        li class: "luminary-close", ->
          a href: "#", ->
            text "Close Luminary >>"
        li class: "active", ->
          a href: "#request-info", ["data-toggle"]: "tab", ->
            text "Request"
        li ->
          a href: "#router-info", ["data-toggle"]: "tab", ->
            text "Router"
        li ->
          a href: "#request-raw", ["data-toggle"]: "tab", ->
            text "Raw"
        li ->
          a href: "#console-tab", ["data-toggle"]: "tab", ->
            text "Console"

    div id: "luminary-body", class: "col-md-10", ->
      div class: "tab-content", ->
        div id: "request-info", class: "tab-pane active", ->
          for _title, _data in pairs @req
            h1 ->
              text _title .. ":"
            pre write _data

        div id: "router-info", class: "tab-pane", ->
          h1 ->
            text "Routes"

          tab_classes = {
            "table"
            --"table-condensed"
            "table-striped"
          }

          element "table", class: table.concat(tab_classes, " "), ->
            tr ->
              th ->
                text "#"
              th ->
                text "Path"
              th ->
                text "Name"
              th ->
                text "Action"

            for n,r in pairs @app.router.routes
              r_path, r_name, r_action = r[1], r[3], r[2]

              row_classes = if r_name\match "luminary"
                  "warning"
                else
                  ""

              tr class: row_classes, ->
                td ->
                  text n
                td ->
                  text r[1]
                td ->
                  text r[3]
                td ->
                  text tostring r[2]

        div id: "request-raw", class: "tab-pane", ->
          pre(write(@))

        div id: "console-tab", class: "tab-pane", ->
          pre "CONSOLE CONTENT HERE"
          @console_content!

  console_content: =>
    raw require("luminary.views.console_tool")\render_to_string!

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

