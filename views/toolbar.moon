
import Widget from require "lapis.html"
import insert, concat from table

class LuminaryIndex extends require "luminary.views.base"
  safe_h1: (h) =>
    h1 ->
      _t = type(h)

      if _t == "string"
        text "#{h}:"
      else
        text "#{h} (#{_t})"

  describe_contents: (d) =>
    _t = type d

    if _t == "table"
      element "table", class: "table table-bordered table-striped", style: "width:100%;", ->
        for _element, _value in pairs d
          tr ->
            td style: "width: 20%; font-weight: bold;", ->
              raw tostring _element
            td style: "width: 80%;", ->
              raw tostring _value
    elseif _t == "string"
      div class: "luminary-data", ->
        text d
    else
      pre "#{d}"

  render_section: (t, d) =>
    @safe_h1 t
    @describe_contents d

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
          for k,v in pairs @req
            @safe_h1 k
            @describe_contents v

          ngx = require "ngx"
          ngx_info = {
            ["Request Stats"]: {
              ["Request Time"]: "#{(ngx.now! * 1000) - (ngx.req.start_time! * 1000)} ms"
              ["HTTP Version"]: ngx.req.http_version!
              ["Status"]: ngx.status
            }
          }

          @render_section(t,d) for t,d in pairs ngx_info

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
          ngx = require "ngx"
          ngx_info = {
            ["Server Configuration"]: {
              ["Nginx version"]: ngx.config.nginx_version
              ["Nginx Lua version"]: ngx.config.ngx_lua_version
              ["Debug build"]: ngx.config.debug
              ["Prefix path"]: ngx.config.prefix!
              ["package.path"]: package.path\gsub ";", ";<br />"
              ["package.cpath"]: package.cpath\gsub ";", ";<br />"
            }
          }

          for section_title, section_data in pairs ngx_info
            h1 ->
              text section_title

            element "table", class: "table table-bordered table-striped", style: "width:100%;", ->
              for _element, _value in pairs section_data
                tr ->
                  td style: "width: 20%; font-weight: bold;", ->
                    raw tostring _element
                  td style: "width: 80%;", ->
                    raw tostring _value

          ngx_vars = {
            "args"
            "body_bytes_sent"
            "content_length"
            "content_type"
            "cookie_test"
            "document_root"
            "document_uri"
            "headers_in"
            "headers_out"
            "host"
            "hostname"
            "http_user_agent"
            "http_referer"
            "is_args"
            "limit_rate"
            "nginx_version"
            "query_string"
            "remote_addr"
            "remote_port"
            "remote_user"
            "request_filename"
            "request_body"
            "request_body_file"
            "request_completion"
            "request_method"
            "request_uri"
            "scheme"
            "server_addr"
            "server_name"
            "server_port"
            "server_protocol"
            "uri"
          }

          @safe_h1 "ngx.var"

          element "table", class: "table table-bordered table-striped", style: "width: 100%", ->
            for _v in *ngx_vars
              tr ->
                td style: "width: 20%; font-weight: bold;", ->
                  text "ngx.var.#{_v}"
                td style: "width: 80%;", ->
                  raw tostring(ngx.var[_v] or "")

          h1 ->
            text "ngx"
          pre ->
            for k,v in pairs ngx
              raw "#{k} : #{v}"

        div id: "l-lapisconsole", class: "tab-pane", ->
          @console_content!

  console_content: =>
    raw require("luminary.views.console_tool")\render_to_string!

