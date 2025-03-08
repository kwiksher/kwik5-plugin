local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new {name = "kwik", publisherId = "com.kwiksher"}

local pluginPath = "plugin.kwik"
---
-- Global
kwikGlobal = {}
kwikGlobal.PATH = "plugin/kwik/"
-- kwikPath = "./plugin/kwik/"
--kwikGlobal.ROOT = ""
kwikGlobal.ROOT = "plugin.kwik."
-- kwikGlobal.tmpltSuffix = "_"  -- for production

local kwikPath = system.pathForFile(kwikGlobal.PATH, system.ResourceDirectory).."/"
print(kwikPath)

local folders = {
  ".",
-- "assets",
-- "assets/images",
-- "assets/images/easing",
-- "assets/images/filters",
-- "assets/images/icons",
-- "assets/images/particles",
-- "assets/kwik",
-- "assets/mui",
-- "assets/mui/icon-font",
"commands",
"commands/app",
"commands/common",
"commands/kwik",
"components",
"components/bookstore",
"components/bookstore/controller",
"components/bookstore/model",
"components/bookstore/smc",
"components/bookstore/view",
"components/common",
"components/custom",
"components/kwik",
"components/mui",
"controller",
-- "editor",
-- "editor/action",
-- "editor/action/actionCommand",
-- "editor/action/controller",
-- "editor/animation",
-- "editor/asset",
-- "editor/asset/controller",
-- "editor/asset/img",
-- "editor/audio",
-- "editor/audio/controller",
-- "editor/audio/img",
-- "editor/book",
-- "editor/controller",
-- "editor/controller/BTree",
-- "editor/controller/properties",
-- "editor/controller/selector",
-- "editor/controller/shape",
-- "editor/group",
-- "editor/group/controller",
-- "editor/interaction",
-- "editor/kwik_json",
-- "editor/layer",
-- "editor/lib",
-- "editor/lib/metalua",
-- "editor/lib/metalua/compiler",
-- "editor/lib/metalua/compiler/bytecode",
-- "editor/lib/metalua/compiler/parser",
-- "editor/lib/metalua/compiler/parser/annot",
-- "editor/lib/metalua/extension",
-- "editor/lib/metalua/grammar",
-- "editor/lib/metalua/treequery",
-- "editor/page",
-- "editor/parts",
-- "editor/physics",
-- "editor/physics/controller",
-- "editor/picker",
-- "editor/replacement",
-- "editor/replacement/controller",
-- "editor/replacement/particles",
-- "editor/scripts",
-- "editor/shape",
-- "editor/timer",
-- "editor/timer/controller",
-- "editor/trash",
-- "editor/variable",
-- "editor/variable/controller",
"extlib",
"extlib/com",
"extlib/com/gieson",
"extlib/lustache",
"extlib/materialui",
"extlib/materialui/material-design-icons",
"extlib/nanostores",
"extlib/nanostores/lib",
"extlib/nanostores/scripts",
"extlib/plugin",
"extlib/plugin/mouseHover",
"extlib/pretty",
"extlib/pretty/json",
"extlib/robotlegs",
"extlib/spyric",
"extlib/transition2lib",
-- "installer",
-- "installer/lustache",
-- "installer/Skins",
-- "lib",
-- "server",
-- "server/controller",
-- "server/docs",
-- "server/pegasus",
-- "server/sampleUI",
-- "server/tests",
-- "template",
-- "template/assets",
-- "template/assets/audios",
-- "template/assets/audios/long",
-- "template/assets/audios/short",
-- "template/assets/audios/sync",
-- "template/assets/audios/sync/en",
-- "template/assets/audios/sync/jp",
-- "template/assets/fonts",
-- "template/assets/images",
-- "template/assets/images/pageX",
-- "template/assets/particles",
-- "template/assets/sprites",
-- "template/assets/thumbnails",
-- "template/assets/videos",
-- "template/commands",
-- "template/commands/pageX",
-- "template/components",
-- "template/components/pageX",
-- "template/components/pageX/animation",
-- "template/components/pageX/animation/defaults",
-- "template/components/pageX/audio",
-- "template/components/pageX/audio/defaults",
-- "template/components/pageX/group",
-- "template/components/pageX/group/defaults",
-- "template/components/pageX/interaction",
-- "template/components/pageX/interaction/defaults",
-- "template/components/pageX/layer",
-- "template/components/pageX/layer/defaults",
-- "template/components/pageX/page",
-- "template/components/pageX/page/controllers",
-- "template/components/pageX/page/defaults",
-- "template/components/pageX/physics",
-- "template/components/pageX/physics/defaults",
-- "template/components/pageX/replacement",
-- "template/components/pageX/replacement/defaults",
-- "template/components/pageX/replacement/particles",
-- "template/components/pageX/replacement/particles/defaults",
-- "template/components/pageX/shape",
-- "template/components/pageX/timer",
-- "template/components/pageX/timer/defaults",
-- "template/components/pageX/variable",
-- "template/components/pageX/variable/defaults",
-- "template/models",
-- "template/models/pageX",
-- "test",
-- "test/animation",
-- "test/book",
-- "test/bookTest",
-- "test/github",
-- "test/interaction",
-- "test/keyboard",
-- "test/lingualSample",
-- "test/replacement",
}

print(package.path)
if lib.pacakge_path_added == nil then
  -- /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D_plugin/lib/util.lua
  for i, folder in next, folders do
    package.path = package.path .. ";" .. kwikPath .. folder .."/?.lua;"
  end
  lib.pacakge_path_added = true
end

lib.useGradientBackground = function(_num)
  -- display.setDefault( "background", 0.8, 0.8, 0.8 )
  -- display.setDefault( "background", 1, 1, 1 )

  -- Create a gradient effect using rectangles Good for emitting particles!
  ---[[
  local numRectangles = _num or 100
  local rectHeight = display.contentHeight / numRectangles
  for i = 1, numRectangles do
    local alpha = 1 - (i / numRectangles) -- Fade from opaque to transparent
    local rect = display.newRect(display.contentCenterX, rectHeight * (i - 0.5), display.contentWidth, rectHeight)
    rect:setFillColor(1, 1, 1, alpha) -- White to transparent gradient
    rect:toBack()
  end
  --]]
end

lib.restore = function()
  --restore = true
  -- if restore then
  --   os.execute("cd " .. system.pathForFile("../", system.ResourceDirectory) .. "; source undo_lua.command")
  --   return
  -- end
  native.requestExit()
end

lib.autoUpdate = function()
  --
  -- require("installer.index").init()
  --
end

lib.setCustomModule = function(pathMod, props)

  lib.lib={}
  lib.lib.util = require("plugin.kwik.lib.util")
  lib.pageCommond = require("plugin.kwik.components.bookstore.controller.pageCommand")
  lib.model = require("plugin.kwik.components.bookstore.model.base")
-- -- lib.lib.util = require("lib.util")
  -- package.path = package.path .. ";" .. path .. "/?.lua;"

  lib.common = props
  require("plugin.kwik.controller.commonComponentHandler").pathMod = pathMod .. ".components."
  require("plugin.kwik.controller.ApplicationContext").pathMod = pathMod .. ".commands."

  for i, name in next, props.components do
    print(pathMod..".components."..name)
    local path = pathMod..".components."..name
    package.loaded[path] = require(path)
    -- package.preload[path] = require(path)
    -- print(package.loaded[path].test)
    if package.loaded[path] == nil then
      print("Error not found", path)
      return false
    end
  end
  return true
end

lib.bootstrap = function(props)
  ---
  local controller = require("plugin.kwik.controller.index")
  props.common = lib.common
  kwikGlobal.gotoLastBook = props.gotoLastBook
  kwikGlobal.unitTest = props.unitTest
  kwikGlobal.httpSever = props.httpSever
  kwikGlobal.showPageName = props.showPageName
  --
  controller.bootstrap(props)
end

-- lib.util = require("plugin.kwik.lib.util")
-- Return library instance

lib.original_require = require

require = function(...)
  local modName = ...
  -- modName = modName:gsub("com.gieson", "extlib.com.gieson")
  -- modName = modName:gsub("Tools", "extlib.com.gieson.Tools")
  -- modName = modName:gsub("TouchHandlerObj", "extlib.com.gieson.TouchHandlerObj")
  modName = modName:gsub("checks", kwikGlobal.ROOT.."extlib.checks")
  modName = modName:gsub("metalua.", kwikGlobal.ROOT.."extlib.metalua.")
  modName = modName:gsub("materialui", kwikGlobal.ROOT.."extlib.materialui")
  modName = modName:gsub("nanostores.index", "nanostores.nanostores")
  modName = modName:gsub("lib.clean%-stores", kwikGlobal.ROOT.."extlib.nanostores.lib.clean-stores")
  modName = modName:gsub("lib.create%-derived", kwikGlobal.ROOT.."extlib.nanostores.lib.create-derived")
  modName = modName:gsub("lib.create%-map", kwikGlobal.ROOT.."extlib.nanostores.lib.create-map")
  modName = modName:gsub("lib.create%-store", kwikGlobal.ROOT.."extlib.nanostores.lib.create-store")
  modName = modName:gsub("lib.define%-map", kwikGlobal.ROOT.."extlib.nanostores.lib.define-map")
  modName = modName:gsub("lib.effect", kwikGlobal.ROOT.."extlib.nanostores.lib.effect")
  modName = modName:gsub("lib.get%-value", kwikGlobal.ROOT.."extlib.nanostores.lib.get-value")
  modName = modName:gsub("lib.keep%-active", kwikGlobal.ROOT.."extlib.nanostores.lib.keep-active")
  modName = modName:gsub("lib.lualib_bundle", kwikGlobal.ROOT.."extlib.nanostores.lib.lualib_bundle")
  modName = modName:gsub("lib.update", kwikGlobal.ROOT.."extlib.nanostores.lib.update")
  return lib.original_require(modName)
end


return lib
