local M = {}

local current = ...
local parent = current:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

-- print(current, parent ,root)
local app = require(kwikGlobal.ROOT.."controller.Application").get()

-- local editor = require(kwikGlobal.ROOT.."editor.index")
-- --editor.lastSelection = { book="book", page=app.props.goPage}


-- local screen = require(parent.."screen")
function M:showSceneCollection()
  local composer = require("composer")
  local name = "sceneCollection"
  local collection = require(kwikGlobal.ROOT.."controller.sceneCollection").new()
  composer.gotoScene( "sceneCollection",  {effect = "flip", time = 1000})
end
--
function M:init(UI)
  -- editor:init(UI)
end
--
function M:create(UI)
  -- editor:create(UI)
end
--
function M:didShow(UI)
  -- editor:didShow(UI)
end
--
function M:didHide(UI)
  -- editor:didHide(UI)
end
--
function M:destroy(UI)
  -- editor:destroy(UI)
end
--
return M
