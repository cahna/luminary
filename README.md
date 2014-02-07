
Luminary
========

A visual debugging toolbar for Lapis websites written in Moonscript.
 
Inspired by Django's debug toolbar, CakePHP's debugkit, and others.

### Goals ###

1. Provide an intuitive, clean, lightweight debug module for moonscript applications (something you'd _want_ to use on every Lapis project)
2. Require minimal configuration
3. Allow further extension and customization of panels
4. Include thorough documentation

## Features ##

* Inspect detailed request and response data from within a browser
* Log SQL queries executed during a request (PostgreSQL only, currently, through `lapis.db`)
* Use [lapis-console](https://github.com/leafo/lapis-console) directly from the overlayed toolbar panel, or access it through the included (but optional) `/luminary/console` route.
* Extensible - Choose which panels to load, override/extend the default panels, or create panels specific to your needs
* Included debug panels:
  - Lapis request inspector
  - Database query log (postgresql through `lapis.db`)
  - Ngx_openresty build & configuration with lua(jit) environment information
  - Router/dispatcher inspector
  - Embedded lapis-console
* Limited to the "development" configuration environment for safety and performance

## Screenshots ##

![Request Panel Screenshot](https://github.com/cahna/luminary/blob/master/examples/screenshots/request-panel.jpg "Request Panel")
![Console Panel Screenshot](https://github.com/cahna/luminary/blob/master/examples/screenshots/console-panel.jpg "Console Panel")

## Dependencies ##

Install via LuaRocks, MoonRocks, build into ngx-openresty, or clone this repo into the top-level directory of your project.

* lapis
* lapis-console
* lua-cjson
* jQuery \*
* Twitter Bootstrap 3 \*

\* Not included with this module, must be placed within your projects manually.

Luminary uses the [Tup](http://gittup.org/tup/) build system.

## Privacy and Security Notice ##

This toolbar should __never__ be exposed to a production/public-facing website. It will expose the entire configuration and
environment of your server, display request contents (including passwords), and impact your site's performance. Luminary will
restrict itself to the "development" environment by default.

## Usage ##

Install the Luminary rock or clone this repository into the top level of your project path. 
Luminary will return a table with 3 entries when `require`d by your application:

```moonscript
require "moon.all"            -- Moonscript's p() function
luminary = require "luminary" -- Load luminary
dump luminary
```

```moonscript
-- Output:
luminary = {
  routes: {
    path: "/luminary"
    __name: "LuminaryRoutes"
    ...
  }
  capture_queries: "function: 0x41x1aa10"
  render_toolbar: "function: 0x41x1ad30"
}
```

### Application ###

`luminary.routes` (class) will create the routes needed for the included hooks into lapis-console to work.
Currently, this is the only functionality provided by `luminary.routes`. If the `console` panel is
disabled, then these routes are not necessary and should be omitted. 

```moonscript
lapis = require "lapis"
luminary = require "luminary"

lapis.serve class MyApp extends lapis.Application
  @include luminary.routes

  -- followed by the rest of your app
```

### Database Queries ###

`luminary.capture_queries(lapis_requst)` must be called as early in your application as possible to capture
queries for each request. Putting this as the first line in your Application's `@before_filter` is 
recommended. If you have disabled the `db` panel, this should be omitted.

```moonscript
import Application from require "lapis.application"

luminary = require "luminary"

class Cheffree extends Application
  @include luminary.routes

  layout: require "views.MyLayout"

  @before_filter =>
    -- Begin db query capture. Pass the request data as the first argument to `capture_queries`
    luminary.capture_queries @

  -- ...
```

### Layout ###

`luminary.render_toolbar(req)` will render the debug toolbar in your layout. This function must be given 
the Lapis request, @, as its argument.

```moonscript
import Widget from require "lapis.html"
import render_toolbar from require "luminary"

class MyLayout extends Widget
  content: =>
    html_5 ->
      head ->
        meta charset: "utf-8"
        meta name: "viewport", content: "width=device-width, initial-scale=1.0"
        
        if @page_description
          meta name: "description", content: @page_description

        title ->
          text @page_title

        link rel: "stylesheet", href: "/static/themes/cardeostrap/css/bootstrap.min.css"
        link rel: "stylesheet", href: "/static/font-awesome/css/font-awesome.min.css"
        link rel: "stylesheet", href: "/static/themes/cardeostrap/css/theme.css"
        link rel: "stylesheet", href: "http://fonts.googleapis.com/css?family=Lato"

      body ->
        -- Where your view/widget content is rendered
        @content_for "inner"

        -- Javascript
        script src: "/static/js/jquery-1.10.2.js"
        script src: "/static/js/bootstrap.js"
        script src: "/static/themes/cardeostrap/js/respond.js"
        script src: "/static/themes/cardeostrap/js/app.js"

        -- Render Luminary debug toolbar (must include that lapis request, @, as an argument)
        raw render_toolbar @
```

## Panels ##

Each link in Luminary's navigation bar corresponds to an associated panel. A panel is simply 
a lapis widget rendered as a tab within the toolbar. Luminary comes with several panels
that are loaded by default:

* `luminary.panels.request`: Lapis request data
* `luminary.panels.router`: Lapis router information
* `luminary.panels.queries`: Database queries performed while serving request (pgsql through lapis.db)
* `luminary.panels.ngx`: OpenResty build information, server configuration, and Nginx variables
* `luminary.panels.environment`: Lapis environment configuration
* `luminary.panels.console`: Embedded lapis-console

Since panels are just Lapis widgets, you can extend Luminary by creating your own panels filled
with whatever debug information you want. Take a look at any of the panels in `luminary/panels/`
for examples, or extend `luminary.panels.base` to get some helper functions in your new panel 
that can help with displaying tabular data.

### Configuring Panels ###

If config.moon doesn't have a luminary entry, the default panels (described above) 
will be loaded. Which panels are loaded and their ordering can be controlled by 
adding a section like the following to config.moon:

```moonscript
import config from require "lapis.config"

config {"development", "test"}, ->
  num_workers 1
  code_cache "off"
  session_name "MyApp"
  postgresql_url "postgres://#{pg.user}:#{pg.pass}@127.0.0.1/#{pg.db}"

  -- This example removes all of the defaults except for the 'request' and 'router' panels
  luminary ->
    panels {
      "luminary.panels.request"
      "luminary.panels.router"
    }
```

Panels are loaded internally using their Lua path (much like Python Debug Toolbar's panel loading scheme)

### Creating Panels ###

Creating custom panels (or overriding the default panels) can be done by making a "luminary"
directory at the top-level of your project tree and a "panels" subdirectory within it, ie: 

```sh
mkdir -p luminary/panels
```

This is just taking advantage of Lua's `package.path` and how panels are configured (described above),
so if you've altered your package path, then loading custom panels might not work as expected. 
Of course, new panels may be placed in the directory where Luminary was installed, or packaged as a
rockspec to be installed and managed by (Lua|Moon)rocks.

__Custom panel example:__

```moonscript
import Widget from require "lapis.html"

class MyPanel extends Widget
  @title = "Router"

  content: =>
    h1 ->
      text "Hello World!"

    pre ->
      "This panel was created at #{os.time!}"
```

The `@title` class variable of a panel controls the link text shown on the Luminary navbar. If omitted, 
Luminary will try to use the class name for the link. If an anonymous class is created with no title, then
a generic title will be shown.

## Other Notes ##

* When `luminary.capture_routes @` is invoked within a `@before_filter()`, @\_luminary is created as a namespace to cache things throughout request processing. Currently, `luminary.panels.db` is the only panel to take advantage of this because it holds the captured queries for the request. It can be debated whether this is a good practice, or if this technically violates the standard Lua practice of never polluting a higher-level namespace. I don't find this to be a problem since I want to have minimal configuration as a feature, and because the request, `@`, is given as an argument (plus I'm documenting this behavior). This will remain until a better idea comes along.

## License ##

Copyright (C) 2014 Conor Heine


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Contact ##

```
Author: Conor Heine <conor.heine@gmail.com>
```

This project is meant to extend @leafo's work developing [Lapis](https://github.com/leafo/lapis) and 
[Lapis-console](https://github.com/leafo/lapis-console), to make Lapis/Moonscript/OpenResty a more
desireable and inviting environment for developers, and to assist in the development of Lapis applications.

