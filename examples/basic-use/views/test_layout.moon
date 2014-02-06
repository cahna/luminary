
import Widget from require "lapis.html"
luminary = require "luminary"

class MyLayout extends Widget
  content: =>
    html_5 ->
      head ->
        meta charset: "utf-8"
        meta name: "viewport", content: "width=device-width, initial-scale=1.0"
        
        if @page_description
          meta name: "description", content: @page_description

        title ->
          if @page_title
            text "#{@page_title} - Hello World"
          else
            text "Hello World"

        link rel: "stylesheet", href: "//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"

      body ->
        @content_for "inner"

        -- Javascript
        script src: "//code.jquery.com/jquery-1.10.2.min.js"
        script src: "//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"

        -- Render Luminary debug toolbar
        raw luminary.render_toolbar @

