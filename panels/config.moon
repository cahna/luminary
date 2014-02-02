
config = require"lapis.config".get!

import label_wrap, float_wrap from require "luminary.panels.util"
import sort, concat from table

class LapisEnvironmentPanel extends require "luminary.panels.base"
  @title = "Lapis Env"

  content: =>
    h1 ->
      text "Lapis Environment Configuration"

    @table_contents config

