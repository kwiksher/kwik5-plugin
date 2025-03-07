local M = {}

function M:init(UI)
end

function M:create(UI)
  local sceneGroup  = UI.sceneGroup
end
--
function M:didShow(UI)
  self.timerObj = timer.performWithDelay( self.properties.delay, function()
      if self.actionName then
        UI.scene:dispatchEvent({name = self.actionName })
      end
    end, self.iterations)
end
--
function M:destroy(UI)
end
--
function M:didHide(UI)
  if self.timerObj then
    timer.cancel(self.timerObj )
    self.timerObj = nil
  end
end

M.set = function(instance)
	return setmetatable(instance, {__index=M})
end

return M