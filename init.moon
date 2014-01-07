
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

import Widget from require "lapis.html"
import write from require "pl.pretty"

class LuminaryHelper extends lapis.Application
  views_prefix: "luminary.views."
  layout: "base"

  @path: "/luminary"
  @name: "luminary_"

  -- A path is needed for the console's AJAX to poke
  [console: "/console"]: =>
    console.make! @

  -- This is what will be rendered manually
  [index: "/"]: =>
    @debug_env = @
    render: require "luminary.views.luminary_index", layout: require "luminary.views.base"

