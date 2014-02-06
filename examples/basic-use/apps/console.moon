
lapis = require "lapis"
console = require "lapis.console"

class ConsoleApp extends lapis.Application
  @path: "/console"
  @name: "console_"

  [index: "/"]: =>
    console.make! @

