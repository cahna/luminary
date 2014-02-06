
class RequestPanel extends require "luminary.panels.base"
  @title = "Request"
  @subtitle = "Lapis #{require 'lapis.version'}"

  content: =>
    @render_section "Request", @req

