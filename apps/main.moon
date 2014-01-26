
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

config = require"lapis.config".get!

import Application, respond_to, capture_errors_json, assert_error, yield_error
  from require "lapis.application"
import assert_valid from require "lapis.validate"
import run, make from require "lapis.console"

class LuminaryConsoleApp extends Application
  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: respond_to {
    GET: =>
      -- TODO: Document config.moon usage
      if config.luminary and config.luminary.enable_get
        make! @
      else
        @write status: 404

    POST: capture_errors_json =>
      @params.lang or= "moonscript"
      @params.code or= ""

      assert_valid @params, {
        { "lang", one_of: {"lua", "moonscript"} }
      }

      if @params.lang == "moonscript"
        moonscript = require "moonscript.base"
        fn, err = moonscript.loadstring @params.code

        if err
          { json: { error: err } }
        else
          lines, queries = run @, fn
          if lines
            { json: { :lines, :queries } }
          else
            { json: { error: queries } }
  }

