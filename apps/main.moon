
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

-- import run from require "lapis.console"

--_G.moon_no_loader = true
export moon_no_loader = true

parse = require "moonscript.parse"
compile = require "moonscript.compile"

import run from require "lapis.console"

--import write from require "pl.pretty"

class LuminaryConsoleApp extends Application
  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: respond_to {
    POST: capture_errors_json =>
      @params.lang or= "moonscript"
      @params.code or= ""

      assert_valid @params, {
        { "lang", one_of: {"lua", "moonscript"} }
      }

      if @params.lang == "moonscript"
        -- moon_code = [[(-> print "hello world")!]]
        moon_code = @params.code

        tree, p_err = parse.string moon_code
        if not tree
          { json: { error: "Parse error: " .. p_err } }

        lua_code, c_err, pos = compile.tree tree

        if not lua_code
          { json: { error: compile.format_error(c_err, pos, moon_code) } }

        else
          lines, queries = run @, loadstring lua_code
          if lines
            { json: { :lines, :queries } }
          else
            { json: { error: queries } }

--    GET: =>
--      console.make! @
--      --{ json: { error: "why you GET?" } }
  }

--  [console: "/console"]: respond_to {
--    POST: =>
--      parse = require "moonscript.parse"
--      compile = require "moonscript.compile"
--
--      -- moon_code = [[(-> print "hello world")!]]
--      moon_code = @params.code
--
--      tree, err = parse.string moon_code
--      if not tree
--        error "Parse error: " .. err
--
--      lua_code, err, pos = compile.tree tree
--      if not lua_code
--        error compile.format_error err, pos, moon_code
--
--      -- our code is ready
--      print lua_code
--
--    GET: =>
--      console.make! @
--  }


  [console: "/console"]: respond_to {
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

    GET: =>
      console.make! @
  }

