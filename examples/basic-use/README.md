
Luminary Basic Use Example
===

Minimum working example of the Luminary debug toolbar.

This example builds upon the default output of `lapis new` by adding the Luminary
toolbar with default panels (including the ability to capture SQL queries) to a 
basic Lapis-powered website. 

Explanation
===

* `web.moon`: Lapis entry point. Serves `apps/app.moon`.
* `apps/app.moon`: Main application class. Served by `web.moon`. Note:
  - `luminary = require "luminary"` at top of file
  - `@include luminary.routes` within the class definition to load the lapis-console panel's needed routes
  - `luminary.capture_requests @` within `@before_filter()` to log SQL queries during request processing
* `views/test_layout.moon`: Application layout. Note:
  - `raw luminary.render_toolbar @` is where Luminary is rendered. Put this at very end of layout before `</body>`
  - Currently, Bootstrap (both its css and js) and jQuery dependecies must be included here manually, ie:
  ```moonscript
  head ->
    -- title, meta, etc...
    link rel: "stylesheet", href: "//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"

  body ->
    @content_for "inner"

    -- Javascript
    script src: "//code.jquery.com/jquery-1.10.2.min.js"
    script src: "//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"

    -- Render Luminary debug toolbar
    raw luminary.render_toolbar @
  ```
