
import config from require 'lapis.config'

-- Try `lapis server production`. Luminary disappears!
config "production", ->
  num_workers 4
  code_cache "on"

-- Luminary will appear in the development environment (with proper usage),
-- and render the default set of included panels.
config "development", ->
  num_workers 1
  code_cache "off"

