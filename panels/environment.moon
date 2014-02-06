
config = require"lapis.config".get!

import label_wrap, float_wrap from require "luminary.util"
import sort, concat from table

class LapisEnvironmentPanel extends require "luminary.panels.base"
  @title = "Lapis Environment"
  @subtitle = config._name

  content: =>
    h1 ->
      text "Lapis Environment Configuration"

    @table_contents config

