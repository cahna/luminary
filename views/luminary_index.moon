
import Widget from require "lapis.html"
import write from require "pl.pretty"

class LuminaryIndex extends Widget
  content: =>
    div id: "luminary-nav", class: "pull-right", ->
      ul class: "nav nav-pills nav-stacked", ->
        li class: "luminary-close", ->
          a href: "#", ->
            text "Close Luminary >>"
        li class: "active", ->
          a href: "#env-info", ["data-toggle"]: "tab", ->
            text "Environment"
        li ->
          a href: "#buffer-info", ["data-toggle"]: "tab", ->
            text "Buffer"
        li ->
          a href: "#request-raw", ["data-toggle"]: "tab", ->
            text "Raw"
        li ->
          a href: "#console-tab", ["data-toggle"]: "tab", ->
            text "Console"

    div id: "luminary-body", class: "col-md-10", ->
      div class: "tab-content", ->
        div id: "env-info", class: "tab-pane active", ->
          h1 ->
            text "Environment"
          ul ->
            for fname, func in pairs @debug_env
              if type fname == "string"
                li ->
                  text fname

          -- Search for the request information
          req = {}

          for k,v in pairs @debug_env
            if type k == "table"
              table.insert req, v

          if req[1]
            h1 ->
              text "Request"
            pre write req[1]

        div id: "buffer-info", class: "tab-pane", ->
          h1 ->
            text "Scope"
          ul ->
            for fname, func in pairs @debug_env.req
              if type fname == "string"
                li ->
                  text fname

        div id: "request-raw", class: "tab-pane", ->
          pre(write(@debug_env))
          pre(write(@))

        div id: "console-tab", class: "tab-pane", ->
          --@console_content!
          pre "CONSOLE CONTENT HERE"



