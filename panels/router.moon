
import insert,concat,sort from table

class RouterPanel extends require "luminary.panels.base"
  @title = "Router"

  content: =>
    h1 ->
      text "Routes"

    tab_classes = {
      "table"
      --"table-condensed"
      "table-striped"
    }

    element "table", class: concat(tab_classes, " "), ->
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

      sort routes, (t1,t2) -> t1[3] < t2[3]

      n = 0
      for {r_path, r_action, r_name} in *routes
        n += 1
        row_classes = {}

        if r_action == default_route
          -- This doesn't work as expected. TODO: highlight default route green
          insert row_classes, "success"
        else if r_name\match "luminary"
          -- Make luminary routes yellow
          insert row_classes, "warning"

        tr class: concat(row_classes), ->
          td ->
            text n
          td ->
            text r_path
          td ->
            text r_name
          td ->
            text tostring r_action

