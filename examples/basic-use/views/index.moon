
import Widget from require "lapis.html"

class IndexView extends Widget
  content: =>
    h1 ->
      text "Welcome to this basic Luminary example and Lapis #{require "lapis.version"}!"

    color,msg = if @is_valid_env
        "#00FF00", "Looks like you're in the 'development' environment! You should see the Luminary toggle button attached to the right of this window."
      else
        "#FF0000", "Luminary is disabled outside of the 'development' environment. The Luminary toggle button shouldn't be shown here."

    h3 style: "color:#{color};", ->
      text msg

