package = "sensai.nvim"
version = "dev-1"
source = {
   url = "git+https://github.com/MXCR-cpu/sensai.nvim.git"
}
description = {
   summary = "**Developement in Progress**",
   detailed = [[
**Developement in Progress**
]],
   homepage = "https://github.com/MXCR-cpu/sensai.nvim",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      ["sensai.config.init"] = "lua/sensai/config/init.lua",
      ["sensai.health"] = "lua/sensai/health.lua",
      ["sensai.init"] = "lua/sensai/init.lua"
   }
}
