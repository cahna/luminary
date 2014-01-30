
Luminary
========

## Description ##

_Luminary_: A visual debugging toolbar for Lapis websites written in Moonscript (also, the program used in the Lunar Module on Apollo's Guidance Computer).
 
Inspired by CakePHP's debugkit, Django's debug toolbar, and others.

This project is meant to extend @leafo's work developing [Lapis](https://github.com/leafo/lapis) and [Lapis-console](https://github.com/leafo/lapis-console), and to make Lapis & Moonscript more inviting and accessible to a wide range of developers. Lapis-console has been forked, bashed around, and included within this module.

### Goals ###

1. Provide an intuitive, clean, debug module for moonscript applications. Make something you'd _want_ to use on every Lapis project.
2. Require minimal configuration: 
  - require module once (or less, ie: enable via lapis config?)
  - add within view once (or less?)
  - allow for further extension with custom panels (maybe later)
  - Don't be intrusive or behave unexpectedly
3. Complete goals list

### Feature Requests / To-do List ###

- [x] Add lapis console
- [ ] Capture database queries
- [ ] Handle rendering conditions from config
- [x] Allow extensions in the form of custom panels. Dynamically load panels.
- [ ] Capture & compile request stats _in progress_
- [ ] Remove bootstrap/jquery/all unnecessary dependencies: http://css-tricks.com/dont-overthink-it-grids/
- [ ] Write tests

### Dependencies ###

Install via LuaRocks, MoonRocks, build into ngx-openresty, or manually include within your project.

* jQuery \*
* Twitter Bootstrap 3 \*
* lapis
* lapis-console
* lua-cjson

\* Not included with this module, must be placed within your projects manually.

## Usage ##

Install the Luminary rock or clone this repository into the top level of your project path. Luminary will return a table with 2 entries when `require`d by your application:

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
  render_toolbar: "function: 0x41x1ad30"
}
```

### Application ###

`luminary.routes` extends lapis.Application and must be included in your application for the 
lapis-console hooks to work.

```moonscript
lapis = require "lapis"
luminary = require "luminary"

lapis.serve class MyApp extends lapis.Application
  @include luminary.routes

  -- followed by the rest of your app
```

### Layout ###

`luminary.render_toolbar(req)` is a function that will render the debug toolbar in your layout. 
Since this is a manually-rendered widget, this function must be given that Lapis request, @, as 
an argument so Luminary may access the request data.

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

        link rel: "stylesheet", href: "/static/themes/#{@theme}/css/bootstrap.min.css"
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

* request: lapis request data
* router: lapis router information
* ngx: OpenResty build information, server configuration, and Nginx variables
* console: embedded lapis-console

Since panels are just Lapis widgets, you can extend Luminary by creating your own panels filled
with whatever debug information you want. Take a look at any of the panels in `luminary/panels/`
for examples, or extend `luminary.panels.base` to get some helper functions in your new panel 
that can help with displaying tabular data.

### Configuring Panels ###

If your Lapis site's config.moon doesn't have a luminary entry, the default panels (described
above) will be loaded. For fine control of which panels to load and their ordering, add a section
like the following to your config.moon:

```moonscript
import config from require "lapis.config"

config {"development", "test"}, ->
  num_workers 1
  code_cache "off"
  session_name "MyApp"
  postgresql_url "postgres://#{pg.user}:#{pg.pass}@127.0.0.1/#{pg.db}"

  -- This example removes the default "ngx" panel
  luminary {
    panels: {
      "request"
      "router"
      "console"
    }
  }
```

Panels are loaded internally using something like:

```moonscript
p = require "luminary.panels.#{panel_name}"
p\include_helper @
```

### Creating Panels ###

Creating your own panels (or overriding the default panels) can be done by making a "luminary"
directory at the top-level of your project tree and a "panels" subdirectory within it, ie: 

```sh
mkdir -p luminary/panels
```

This is just taking advantage of your `package.path` and how panels are configured (described above),
so if you've altered your package path then loading custom panels might not work as expected. 
Of course, you could just place any new panels in the directory where Luminary was installed, or 
you could write up a rockspec if you make a really awesome panel that others could benefit from using.

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

The `@title` class variable of your panel controls the link text shown on the Luminary navbar. If omitted, 
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

