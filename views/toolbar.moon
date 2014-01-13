
import Widget from require "lapis.html"
import write from require "pl.pretty"

import insert, concat from table

class LuminaryIndex extends require "luminary.views.base"
  safe_h1: (h) =>
    h1 ->
      _t = type(h)

      if _t == "string"
        text "#{h}:"
      else
        text "#{write h} (#{_t})"

  describe_contents: (d) =>
    _t = type d

    if _t == "table"
      dl class: "luminary-data dl-horizontal", ->
        for k,v in pairs d
          dt ->
            text k
          dd ->
            text v
    elseif _t == "string"
      div class: "luminary-data", ->
        text d
    else
      pre write dict

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
          a href: "#console-tab", ["data-toggle"]: "tab", id: "nav-console-tab", ->
            text "Console"

    div id: "luminary-body", class: "col-md-10", ->
      div class: "tab-content", ->
        div id: "request-info", class: "tab-pane active", ->
          for k,v in pairs @req
            @safe_h1 k
            @describe_contents v

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

        div id: "request-raw", class: "tab-pane", ->
          pre(write(@))

        div id: "console-tab", class: "tab-pane", ->
          @console_content!

  console_content: =>
    raw require("luminary.views.console_tool")\render_to_string!

