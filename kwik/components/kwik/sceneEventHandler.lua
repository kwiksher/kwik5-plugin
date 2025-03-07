local _Class = {}
--
function _Class:setMod(type, layer, custom)
  local fileName = layer
  if type then
    fileName = layer .."_"..type
  end
  if custom then
    --print("custom.components."..self.page.."."..fileName)
    self.mod = require("custom.components."..self.UI.page.."."..fileName)
  else
    --print("components."..self.page.."."..fileName)
    self.mod = require(kwikGlobal.ROOT.."components."..self.UI.page.."."..fileName)
  end
end
--
function _Class:_init(type, layer, custom)
  self:setMod(type, layer, custom)
  if self.mod.init then
    self.mod:init(self.UI)
  end
end
--
local typesForPageCurl = {
  button=true, image=true, filter=true
}
--
function _Class:_create(type, layer, custom)
  self:setMod(type, layer, custom)
  -- dummy is pageCurl UI creation
  if self.mod.create and (self.dummy == nil or typesForPageCurl[type])  then
    self.mod:create(self.UI)
  end
end
--
function _Class:_willShow(type, layer, custom)
  self:setMod(type, layer, custom)
  if self.mod.willShow then
    self.mod:willShow(self.UI)
  end
end
--
function _Class:_willHide(type, layer, custom)
  self:setMod(type, layer, custom)
  if self.mod.willHide then
    self.mod:willHide(self.UI)
  end
end
--
function _Class:_didShow(type, layer, custom)
  self:setMod(type, layer, custom)
  if self.mod.didShow then
    self.mod:didShow(self.UI)
  end
end
--
function _Class:_didHide(type, layer, custom)
  self:setMod(type, layer, custom)
  if self.mod.didHide then
    self.mod:didHide(self.UI)
  end
end
--
function _Class:_destroy(type, layer, custom)
  self:setMod(type, layer, custom)
  if self.mod.destroy then
    self.mod:destroy(self.UI)
  end
end
--
function _Class:_resume(type, layer, custom)
  self:setMod(type, layer, custom)
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