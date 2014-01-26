
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

json = require "cjson"
json.encode_max_depth 1000

lapis = require "lapis.init"
config = require"lapis.config".get!

import Application, respond_to, capture_errors_json, assert_error, yield_error
  from require "lapis.application"
import assert_valid from require "lapis.validate"
import insert from table

--import run from require "luminary.console"

console = require "luminary.console"

moonscript = require "moonscript.base"

raw_tostring = (o) ->
  if meta = type(o) == "table" and getmetatable o
    setmetatable o, nil
    with tostring o
      setmetatable o, meta
  else
    tostring o

encode_value = (val, seen={}, depth=0) ->
  depth += 1
  t = type val
  switch t
    when "table"
      if seen[val]
        return { "recursion", raw_tostring(val) }

      seen[val] = true

      tuples = for k,v in pairs val
        { encode_value(k, seen, depth), encode_value(v, seen, depth) }

      if meta = getmetatable val
        insert tuples, {
          { "metatable", "metatable" }
          encode_value meta, seen, depth
        }

      { t, tuples }
    else
      { t, raw_tostring val }


run = (_self, fn using encode_value) ->
  lines = {}
  queries = {}

  _p = (... using insert, lines, queries) ->
    count = select "#", ...
    insert lines, [ encode_value (select i, ...) for i=1,count ]

  scope = setmetatable {
    self: _self
    print: _p
  }, __index: _G

  db = require "lapis.db"
  old_logger = db.get_logger!
  db.set_logger {
    query: (q) ->
      insert queries, q
      old_logger.query q if old_logger
  }

  setfenv fn, scope
  ret = { pcall fn }
  
  unless ret[1]
    return unpack ret, 1, 2

  db.set_logger old_logger
  lines, queries

class LuminaryConsoleApp extends Application
  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke

  [console: "/console"]: respond_to {
    GET: console.make!

    POST: capture_errors_json =>
      @params.lang or= "moonscript"
      @params.code or= ""

      assert_valid @params, {
        { "lang", one_of: {"lua", "moonscript"} }
      }

      if @params.lang == "moonscript"
        -- moonscript = require "moonscript.base"
        -- fn, err = moonscript.loadstring @params.code
        lua_code, ltable = moonscript.to_lua @params.code

        print "REQ (SELF): #{@}"
        print "LUA_CODE: #{lua_code}"

        fn, err = loadstring lua_code

        if err
          { json: { error: err } }
        else
          lines, queries = run @, fn
          if lines
            { json: { :lines, :queries } }
          else
            { json: { error: queries } }
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

