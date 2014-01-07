
---
-- Luminary: A visual debugging toolbar for lapis
-- (also, the program used in the Lunar Module on Apollo's Guidance Computer)
-- 
-- Goals:
-- 1. Provide an intuitive, clean, debug module for moonscript applications
-- 2. Require minimal configuration: 
--    - require module once (or less, ie: enable via lapis config)
--    - add within view once (or less)
--    - allow for further extension with custom panels (maybe later)
-- 3. Take inspiration from CakePHP's debugkit and Django's debug toolbar
--
-- Todo:
-- - Add lapis console
-- - Render only from predefined internal IPs
-- - Remove bootstrap and/or jquery dependencies
--

lapis = require "lapis"
console = require "luminary.console"
js = require "helpers.javascript"

import Widget from require "lapis.html"
import write from require "pl.pretty"

class LuminaryHelper extends lapis.Application
  @path: "/luminary"
  @name: "luminary_"

  @before_filter =>
    -- Cache js for later rendering in the layout
    unless @JsHelper and type @JsHelper == "function"
      @JsHelper = js!

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: =>
    console.make! @

  -- This is what will be rendered manually
  [index: "/"]: =>
    @debug_env = @
   
    local f

    for i,v in ipairs @app.router.routes
      if v[3] == "luminary_index"
        f = v[2]

    @html ->
      f(@req)

    render: require "luminary.views.luminary_index", layout: require "luminary.views.base"

