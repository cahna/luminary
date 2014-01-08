
import Widget from require "lapis.html"

class LuminaryViewUtil extends Widget
  include_script: (name, path = "assets") =>
    script type: "text/javascript", ->
      raw require "luminary.#{path}.#{name}_js"

  include_style: (name, path = "assets") =>
    style type: "text/css", ->
      raw require "luminary.#{path}.#{name}_css"

