local original_require = require

-- TODO load once and set it for package.loaded[]

-- require = function(...)
--   local modName = ...
--   -- modName = modName:gsub("com.gieson", "extlib.com.gieson")
--   -- modName = modName:gsub("Tools", "extlib.com.gieson.Tools")
--   -- modName = modName:gsub("TouchHandlerObj", "extlib.com.gieson.TouchHandlerObj")
--   modName = modName:gsub("materialui", kwikGlobal.ROOT.."extlib.materialui")
--   modName = modName:gsub("nanostores.index", "nanostores.nanostores")
--   modName = modName:gsub("lib.clean%-stores", kwikGlobal.ROOT.."extlib.nanostores.lib.clean-stores")
--   modName = modName:gsub("lib.create%-derived", kwikGlobal.ROOT.."extlib.nanostores.lib.create-derived")
--   modName = modName:gsub("lib.create%-map", kwikGlobal.ROOT.."extlib.nanostores.lib.create-map")
--   modName = modName:gsub("lib.create%-store", kwikGlobal.ROOT.."extlib.nanostores.lib.create-store")
--   modName = modName:gsub("lib.define%-map", kwikGlobal.ROOT.."extlib.nanostores.lib.define-map")
--   modName = modName:gsub("lib.effect", kwikGlobal.ROOT.."extlib.nanostores.lib.effect")
--   modName = modName:gsub("lib.get%-value", kwikGlobal.ROOT.."extlib.nanostores.lib.get-value")
--   modName = modName:gsub("lib.keep%-active", kwikGlobal.ROOT.."extlib.nanostores.lib.keep-active")
--   modName = modName:gsub("lib.lualib_bundle", kwikGlobal.ROOT.."extlib.nanostores.lib.lualib_bundle")
--   modName = modName:gsub("lib.update", kwikGlobal.ROOT.."extlib.nanostores.lib.update")
--   return original_require(modName)
-- end

--dmc = require(kwikGlobal.ROOT.."extlib.dmc_utils")
