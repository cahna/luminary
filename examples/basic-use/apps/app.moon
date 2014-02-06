
import Application from require "lapis"
luminary = require "luminary"

class HelloWorld extends Application
  layout: require "views.test_layout"

  -- Load routes needed by the lapis-console panel and create '/luminary/console'
  @include luminary.routes

  @before_filter =>
    -- Put this at the top of your before_filter() asap to begin logging db queries
    luminary.capture_queries @

  [index: "/"]: =>
    config = require"lapis.config".get!

    @page_title = "Luminary - Basic Use Example"
    @page_description = "A minimum working example of the Luminary debug toolbar within a Lapis website."
    @is_valid_env = config and config._name == "development"

    render: true

