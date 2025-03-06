local M = require(kwikGlobal.ROOT.."extlib.com.gieson.PopUp")

local transitionTime = 500
local transitionKillerOff = nil

local options = {
  text = "",
  font = native.systemFont,
  fontSize = 10,
  align = "left"
}

local function tap(event)
  print("tap")
  if event.eventName == "popup.save" then
    if M.activeEntryX then
      local function getValue(num)
        local t = "+"
        if num < 0  then
          t = "-"
        end
        return t ..num
      end
      if M.bodyName then
        M.activeEntryX.field.text = M.bodyName..".x" .. getValue(M.pointA.newX)
        M.activeEntryY.field.text = M.bodyName ..".y" ..getValue(M.pointA.newY)
      else
        print(M.pointA.newX, M.pointA.newY)
        M.activeEntryX.text = M.pointA.newX
        M.activeEntryY.text = M.pointA.newY
      end
    end
  else -- cancel
    M.pointA:setValueXY(M.pointA.oriX, M.pointA.oriY)
  end
  transition.to( M, { time=transitionTime, alpha=0.0, onComplete=transitionKillerOff })
  return true
end

function M:createButton(params)
  options.parent = self
  options.text = params.text
  options.x = params.x
  options.y = params.y

  local obj = display.newText(options)
  --obj.anchorY=0.5
  obj.tap = tap
  obj.eventName = params.eventName
  obj:addEventListener("tap", obj )
  -- obj.anchorX =0

  local rect = display.newRoundedRect(obj.x, obj.y, 40, obj.height + 2, 10)
  self:insert(rect)
  self:insert(obj)
  rect:setFillColor(0, 0, 0.8)
  obj.rect = rect
  -- rect.anchorX = 0
  return obj.rect
end

local obj = M:createButton {
  text = "Save",
  x = 45,
  y = 30,
  eventName = "popup.save"
}

local obj = M:createButton {
  text = "Cacnel",
  x = 85,
  y = 30,
  eventName = "popup.cancel"
}

function M:off(dragger)
end

function M:onMove(pointA, x, y)
  pointA.newX = x
  pointA.newY = y
  self.pointA = pointA
end

return M
