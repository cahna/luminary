
import render_html from require "lapis.html"
import label_wrap, float_wrap from require "luminary.util"
import sort, concat from table

format_query = (q) ->
  render_html ->
    span style: "font-family: Monaco, Menlo, Consolas, 'Courier New', monospace;", ->
      span style: "color:magenta;font-weight:bold;", ->
        text "SQL: "
      span style: "color:navy;", ->
        raw q

class DatabasePanel extends require "luminary.panels.base"
  @title = "Queries"

  content: =>
    -- luminary.capture_queries! must be called early in the app's request handling for queries to be captured
    h1 ->
      text "Queries"

    if @_luminary
      if @_luminary.queries
        n=0
        for i,q in ipairs @_luminary.queries
          @_luminary.queries[i] = format_query q
          n+=1

        if n>0
          @table_contents @_luminary.queries
        else
          pre ->
            text "No queries captured"
      else
        pre ->
          text "Query capture error!"
    else
      pre ->
        "Unable to capture queries. Did you add `luminary.capture_queries!` to your @before_filter? Check your configuration."

