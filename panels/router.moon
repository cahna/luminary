
import insert,concat,sort from table

-- Used to sort lapis routes table by route name
route_sorter = (t1,t2) ->
  return t1[3] < t2[3]

class RouterPanel extends require "luminary.panels.base"
  title: "Router"

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

      sort routes, route_sorter

      n = 0
      for {r_path, r_action, r_name} in *routes
        n += 1
        row_classes = {}

        if r_action == default_route
          insert row_classes, "success"
        else if r_name\match "luminary"
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

--    h1 ->
--      text "GET Params"
--
--    @table_contents @req.params_get
--
--    for k,v in pairs @req
--      @safe_h1 k
--      @table_contents v

