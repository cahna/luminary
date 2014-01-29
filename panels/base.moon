
import Widget from require "lapis.html"

class PanelBase extends Widget
  @title = "Panel Title"

  content: =>
    h1 "Extend this class to create your own Luminary Panels!"

  safe_h1: (h) =>
    h1 ->
      _t = type(h)

      if _t == "string"
        text "#{h}:"
      else
        text "#{h} (#{_t})"

  table_contents: (d) =>
    _t = type d

    if _t == "table"
      element "table", class: "table table-bordered table-striped", style: "width:100%;", ->
        for _element, _value in pairs d
          tr ->
            td style: "width: 20%; font-weight: bold;", ->
              raw tostring _element
            td style: "width: 80%;", ->
              if type(_value) == "table"
                -- TODO: At some point I should probably ensure this doesn't recurse endlessly
                @table_contents(_value)
              else
                raw tostring _value
    elseif _t == "string"
      div class: "luminary-data", ->
        text d
    else
      pre "#{d}"

  tuple_table: (t) =>
    return unless type(t) == "table"

    element "table", class: "table table-bordered table-striped", style: "width:100%;", ->
      for {directive, value} in *t
        tr ->
          td style: "width: 20%; font-weight: bold;", ->
            raw tostring directive
          td style: "width: 80%;", ->
            raw tostring value

  render_section: (t, d) =>
    @safe_h1 t
    @table_contents d

