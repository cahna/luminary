
import slugify from require "lapis.util"
import insert, concat from table

defaults = {
  "luminary.panels.request"
  "luminary.panels.db"
  "luminary.panels.ngx"
  "luminary.panels.router"
  "luminary.panels.environment"
  "luminary.panels.console"
}

class LuminaryIndex extends require "luminary.views.base"
  load_panel: (path) =>
    panel = require path
    panel\include_helper @
    panel

  load_all: (names) =>
    conf = {}
    for i,name in ipairs names
      panel = @load_panel name
      id = "luminary-#{i}-#{slugify panel.title or panel.__name or 'DefaultPanel'}"
      insert(conf, {id, panel.title, panel})
    conf

  render_nav: (conf) =>
    div id: "luminary-nav", class: "pull-right", ->
      ul class: "nav nav-pills nav-stacked", ->
        li class: "luminary-close", ->
          a href: "#", ->
            text "Close Luminary >>"

        -- Create panel links with bootstrap data-toggle
        for n,c in ipairs conf
          id,title = c[1], c[2]
          li class: (n == 1 and "active" or nil), ->
            a href: "##{id}", ["data-toggle"]: "tab", ->
              text tostring title

  render_panels: (panels) =>
    div id: "luminary-body", class: "col-md-10", ->
      div class: "tab-content", ->
        for i,{id, title, panel} in ipairs panels
          div id: "#{id}", class: "tab-pane #{i == 1 and 'active'}", ->
            raw panel\render_to_string!


  inner_content: =>
    panels = @load_all defaults

    @render_nav panels

    @render_panels panels

