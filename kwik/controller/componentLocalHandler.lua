local _Class = {}
--
local dir = ...
local parent = dir:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

function _Class:setMod(class, layer, custom)
  local fileName = layer
  if class then
    fileName = class.."."..layer
  end
  if custom then
    --print("custom.components."..self.page.."."..fileName)
    self.mod = require("App."..self.UI.props.appName..".custom.components."..self.UI.page.."."..fileName)
  else
    --print("components."..self.page.."."..fileName)
    self.mod = require("App."..self.UI.props.appName..".components."..self.UI.page.."."..fileName)
  end
end
--
function _Class:_init(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.init then
    self.mod:init(self.UI)
  end
end
--
local typesForPageCurl = {
  button=true, image=true, filter=true
}
--
function _Class:_create(class, layer, custom)
  self:setMod(class, layer, custom)
  -- dummy is pageCurl UI creation
  if self.mod.create and (self.dummy == nil or typesForPageCurl[class])  then
    self.mod:create(self.UI)
  end
end
--
function _Class:_willShow(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.willShow then
    self.mod:willShow(self.UI)
  end
end
--
function _Class:_willHide(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.willHide then
    self.mod:willHide(self.UI)
  end
end
--
function _Class:_didShow(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.didShow then
    self.mod:didShow(self.UI)
  end
end
--
function _Class:_didHide(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.didHide then
    self.mod:didHide(self.UI)
  end
end
--
function _Class:_destroy(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.destroy then
    self.mod:destroy(self.UI)
  end
end
--
function _Class:_resume(class, layer, custom)
  self:setMod(class, layer, custom)
  if self.mod.resume then
    self.mod:resume(self.UI)
  end
end
--
_Class.new = function(_UI)
  local handler = {UI=_UI}
	return setmetatable(handler, {__index=_Class})
end
--
return _Class