
import insert, concat from table

defaults = {
  "request"
  "nginx"
  "router"
}

class LuminaryIndex extends require "luminary.views.base"
  load_panel: (path) =>
    panel = require path
    panel\include_helper @
    panel

  load_all: ->
    conf = {}
    for i,name in ipairs defaults
      panel = @load_panel "luminary.panels.#{name}"
      selector = "#luminary-#{i}-#{slugify panel.name}"
      insert conf, {:selector, panel.name, panel}
    conf

  render_nav: (conf) =>
    div id: "luminary-nav", class: "pull-right", ->
      ul class: "nav nav-pills nav-stacked", ->
        li class: "luminary-close", ->
          a href: "#", ->
            text "Close Luminary >>"

        -- Create panel links with bootstrap data-toggle
        for n,{selector,title,_obj} in ipairs conf
          li class: (n == 1 and "active" or nil), ->
            a href: tostring(selector), ["data-toggle"]: "tab", ->
              text tostring title

  inner_content: =>
    @render_nav {
      {"#l-requestinfo", "Request"}
      {"#l-routerinfo", "Router"}
      {"#l-rawrequest", "Raw"}
      {"#l-ngxinfo", "ngx_openresty"}
      {"#l-lapisconsole", "Console!"}
    }

    div id: "luminary-body", class: "col-md-10", ->
      div class: "tab-content", ->
        div id: "l-requestinfo", class: "tab-pane active", ->
          request_info = @load_panel "luminary.panels.request"
          raw request_info\render_to_string!

        div id: "l-routerinfo", class: "tab-pane", ->
          router_info = @load_panel "luminary.panels.router"
          raw router_info\render_to_string!

        div id: "l-rawrequest", class: "tab-pane", ->
          pre "#{@}"

        div id: "l-ngxinfo", class: "tab-pane", ->
          raw (require "luminary.panels.ngx_info")\render_to_string!

        div id: "l-lapisconsole", class: "tab-pane", ->
          raw require("luminary.views.console_tool")\render_to_string!

