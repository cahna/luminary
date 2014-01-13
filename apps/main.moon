
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

import Application, respond_to, capture_errors_json from require "lapis.application"
import assert_valid from require "lapis.validate"

console = require "luminary.console"

class LuminaryConsoleApp extends Application
  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: respond_to {
    POST: =>
      parse = require "moonscript.parse"
      compile = require "moonscript.compile"

      -- moon_code = [[(-> print "hello world")!]]
      moon_code = @params.code

      tree, err = parse.string moon_code
      if not tree
        error "Parse error: " .. err

      lua_code, err, pos = compile.tree tree
      if not lua_code
        error compile.format_error err, pos, moon_code

      -- our code is ready
      print lua_code
    GET: =>
      console.make! @
  }

--  [console: "/console"]: respond_to {
    -- before: =>
      -- ...

    -- GET: console.make! -- =>
      -- make! @
      -- @write redirect_to: @req.headers.referer or @url_for("index") or "/"
--  }

