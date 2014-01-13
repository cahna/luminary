
---
-- Luminary Console: Proxy for the modified version of lapis-console included
-- with the Luminary package (luminary.console).
--
-- This module should be required in your main lapis application (usually 
-- web.moon) to provide a POST-only interface for the modified lapis-console
-- to direct it's AJAX requests.
--
-- TODO: Enable/disable this Application via lapis config file
-- TODO: Enable respond_to "GET" if enabled in lapis config file
-- 

lapis = require "lapis"
console = require "luminary.console"

import Application, respond_to from require "lapis.application"
import Widget from require "lapis.html"

class LuminaryConsoleApp extends Application
  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: respond_to {
    before: =>
      print "TODO: console before_filter"

    POST: =>
      console.make! @

    GET: =>
      @write redirect_to: @req.headers.referer or @url_for("index") or "/"
  }

