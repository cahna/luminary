package = "luminary"
version = "dev-1"

source = {
  url = "git@github.com:cahna/luminary.git"
}

description = {
  summary = "A visual debugging toolbar for Lapis websites.",
  maintainer = "Conor Heine <cheine@gmail.com>",
  license = "MIT",
}

dependencies = {
  "lua == 5.1",
  "moonscript",
  "lapis",
  "lapis-console"
}

build = {
  type = "builtin",
  modules = {
    ["luminary"] = "init.lua",
  }
}
