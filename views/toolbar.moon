
import insert, concat from table

class LuminaryIndex extends require "luminary.views.base"
  inner_content: =>
    div id: "luminary-nav", class: "pull-right", ->
      ul class: "nav nav-pills nav-stacked", ->
        li class: "luminary-close", ->
          a href: "#", ->
            text "Close Luminary >>"
        li class: "active", ->
          a href: "#l-requestinfo", ["data-toggle"]: "tab", ->
            text "Request"
        li ->
          a href: "#l-routerinfo", ["data-toggle"]: "tab", ->
            text "Router"
        li ->
          a href: "#l-rawrequest", ["data-toggle"]: "tab", ->
            text "Raw"
        li ->
          a href: "#l-ngxinfo", ["data-toggle"]: "tab", ->
            text "ngx_openresty"
        li ->
          a href: "#l-lapisconsole", ["data-toggle"]: "tab", id: "nav-console-tab", ->
            text "Console"

    div id: "luminary-body", class: "col-md-10", ->
      div class: "tab-content", ->
        div id: "l-requestinfo", class: "tab-pane active", ->
--          for k,v in pairs @req
--            @safe_h1 k
--            @describe_contents v
--
--          ngx = require "ngx"
--          ngx_info = {
--            ["Request Stats"]: {
--              ["Request Time"]: "#{(ngx.now! * 1000) - (ngx.req.start_time! * 1000)} ms"
--              ["HTTP Version"]: ngx.req.http_version!
--              ["Status"]: ngx.status
--            }
--          }
--
--          @render_section(t,d) for t,d in pairs ngx_info

        div id: "l-routerinfo", class: "tab-pane", ->
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

            {:default_route, :routes} = @app.router

            for n,r in pairs routes
              r_path, r_name, r_action = r[1], r[3], r[2]

              row_classes = {}

              if r_action == default_route
                insert row_classes, "success"
              else if r_name\match "luminary"
                insert row_classes, "warning"

              tr class: concat(row_classes), ->
                td ->
                  text n
                td ->
                  text r[1]
                td ->
                  text r[3]
                td ->
                  text tostring r[2]

        div id: "l-rawrequest", class: "tab-pane", ->
          pre "#{@}"

        div id: "l-ngxinfo", class: "tab-pane", ->
          raw (require "luminary.panels.ngx_info")\render_to_string!

        div id: "l-lapisconsole", class: "tab-pane", ->
          raw require("luminary.views.console_tool")\render_to_string!

