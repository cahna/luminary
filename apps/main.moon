
---
-- Luminary Console: Proxy for the modified version of lapis-console included
-- with the Luminary package (luminary.console)
-- 

lapis = require "lapis"
console = require "luminary.console"
js = require "lapis.helper.javascript"

import Application, respond_to from require "lapis.application"
import Widget from require "lapis.html"

class LuminaryConsoleApp extends Application
  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: respond_to {
    before: =>
      print "console before_filter"

    POST: =>
      console.make! @

    GET: =>
      @write redirect_to: @req.headers.referer or @url_for("index") or "/"
  }

