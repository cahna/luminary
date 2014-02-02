
Luminary
========

A visual debugging toolbar for Lapis websites written in Moonscript.
 
Inspired by CakePHP's debugkit, Django's debug toolbar, and others.

This project is meant to extend @leafo's work developing [Lapis](https://github.com/leafo/lapis) and 
[Lapis-console](https://github.com/leafo/lapis-console), to make Lapis/Moonscript/OpenResty a more
desireable and inviting environment for developers, and to help in debugging Lapis applications.

### Goals ###

1. Provide an intuitive, clean, lightweight debug module for moonscript applications (something you'd _want_ to use on every Lapis project)
2. Require minimal configuration
3. Allow further extension and customization of panels
4. Include thorough documentation

### Feature Requests / To-do List ###

- [x] Add lapis console
- [x] Capture database queries
- [ ] Handle rendering conditions from config _in progress_
- [x] Allow extensions in the form of custom panels. Dynamically load panels.
- [ ] Capture & compile request stats _in progress_
- [ ] Remove bootstrap/jquery/all unnecessary dependencies: http://css-tricks.com/dont-overthink-it-grids/
- [ ] Write tests
- [ ] Capture log messages, errors, warnings, etc

## Features ##

* Included debug panels:
  - Lapis request inspector
  - Database query log (postgresql through `lapis.db`)
  - Ngx_openresty build & configuration with lua(jit) environment information
  - Router/dispatcher inspector
  - Embedded lapis-console
* Extensible - Easily override the default panels, or create panels specific to your needs
* Limited to the "development" configuration environment

## Dependencies ##

Install via LuaRocks, MoonRocks, build into ngx-openresty, or clone this repo into the top-level directory of your project.

* jQuery \*
* Twitter Bootstrap 3 \*
* lapis
* lapis-console
* lua-cjson
* [Tup](http://gittup.org/tup/) (to build sources, optional)

\* Not included with this module, must be placed within your projects manually.

Luminary uses the Tup build system.

## Privacy and Security Notice ##

This toolbar should __never__ be exposed to a production/public-facing website. It will expose the entire configuration and
environment of your server, display request contents (including passwords), and slow down your site. Luminary will
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

* __request__: Lapis request data
* __router__: Lapis router information
* __queries__: Database queries performed while serving request (pgsql through lapis.db)
* __ngx__: OpenResty build information, server configuration, and Nginx variables
* __environment__: Lapis environment configuration
* __console__: Embedded lapis-console

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

  -- This example removes the default "ngx" panel
  luminary ->
    panels {
      "request"
      "router"
      "console"
    }
```

Panels are loaded internally using something like:

```moonscript
p = require "luminary.panels.#{panel_name}"
p\include_helper @
```

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

## License ##

Copyright (C) 2014 Conor Heine


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Libraries included with Luminary ###

* jQuery
* CodeMirror
* lapis-console

## Contact ##

```
Author: Conor Heine <conor.heine@gmail.com>
```

