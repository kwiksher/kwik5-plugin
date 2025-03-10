local M = {}
--
local util = require "lib.util"
--
-- Infinity background animation
--
local function infinityBackHandler(self, event)
  local xd, yd = self.x, self.y
  local props = self.infinityProps
  -- printKeys(self)
  -- count = count + 1
  -- if count > 10 then return end
  --
  if (props.direction == "left") then --horizontal loop
    if self.x < display.contentCenterX - self.width/2 - self.width then
      self.x = display.contentCenterX + self.width/2
    else
      self.x = self.x - props.speed
    end
  elseif (props.direction == "right") then --horizontal loop
    if self.x   >  display.contentCenterX + self.width/2  then
      self.x = self.oriX-self.width
    else
      self.x = self.x + props.speed
    end
  elseif (props.direction == "up") then --vertical loop
    if self.y < display.contentCenterY - self.height/2 - self.height then
      self.y = display.contentCenterY + self.height/2
    else
      self.y = self.y - props.speed
    end
  elseif (props.direction == "down") then --vertical loop
    if self.y > display.contentCenterY + self.height/2 then
      self.y = display.contentCenterY - self.height - self.height/2
    else
      self.y = self.y + props.speed  -- Changed from - to + for downward movement
    end
  end
  --[[
    if (props.direction == "left" or props.direction == "right") then
    xd = self.width
    if (props.distance ~= nil) then
      xd = self.width + props.distance
    end
  elseif (props.direction == "up" or props.direction == "down") then
    yd = self.height
    if (props.distance ~= nil) then
      yd = self.height + props.distance
    end
  end
  --
  if (props.direction == "left" or props.direction == "right") then
    xd = self.width
    if (props.distance ~= nil) then
      xd = self.width + props.distance
    end
  elseif (props.direction == "up" or props.direction == "down") then
    yd = self.height
    if (props.distance ~= nil) then
      yd = self.height + props.distance
    end
  end
  if (props.direction == "left") then --horizontal loop
    if self.x < (-xd + (props.speed * 2) + self.width/4) then
      self.x = xd + self.width/4
    else
      self.x = self.x - props.speed
    end
  elseif (props.direction == "right") then --horizontal loop
    -- if self.x   > (xd - (props.speed * 2) + self.width/4) then
    if self.x   > self.oriX  + self.width/2  then
      self.x = self.oriX
      -- self.x = self.x  -xd*2 --  + self.width/4
      -- print(self.x, xd - (props.speed * 2), self.width/8)
    else
      self.x = self.x + props.speed
    end
  elseif (props.direction == "up") then --vertical loop
    if self.y < (-yd + (props.speed * 2)) then
      self.y = yd
    else
      self.y = self.y - props.speed
    end
  elseif (props.direction == "down") then --vertical loop
    if self.y > (yd - (props.speed * 2)) then
      self.y = -yd
    else
      self.y = self.y + props.speed
    end
  end
  --]]
end
--
function M.createInfinityImage(UI, layer_1, props)
  print(props)
  props.width = layer_1.width
  local sceneGroup = UI.sceneGroup
  local layer_2 =
     display.newImageRect(UI.props.imgDir .. layer_1.imagePath, UI.props.systemDir, layer_1.width, layer_1.height)
  layer_1.infinityProps = props
  layer_2.infinityProps = props
  -- layer_2 = newImageRect({{bn}}, imageWidth, imageHeight )
  if layer_2 == nil then
    return
  end
  layer_2.blendMode = layer_1.blendMode
  sceneGroup:insert(layer_2)
  sceneGroup[layer_1.name .. "_2"] = layer_2

  --
  local marginX =  display.contentCenterX - layer_1.width/2
  local marginY =  layer_1.height/2

  -- props.direction = "left"
  --
  layer_1.anchorX = 0
  layer_1.anchorY = 0
  util.repositionAnchor(layer_1, 0, 0)
  --
  layer_2.anchorX = 0
  layer_2.anchorY = 0
  util.repositionAnchor(layer_2, 0, 0)
  --
  if props.direction == "up" then
    layer_1.x = layer_1.oriX
    layer_1.y = 0 + marginY
    if props.distance > 0 then
      layer_2.y = layer_1.height + props.distance
      layer_2.x = layer_1.oriX
    else
      layer_2.y = layer_1.height
      layer_2.x = layer_1.oriX
    end
    layer_2.oriY = layer_1.y
  elseif props.direction == "down" then
    layer_1.x = layer_1.oriX
    layer_1.y = 0 - marginY
    if props.distance > 0 then
      layer_2.y = -layer_1.height - props.distance
      layer_2.x = layer_1.oriX
    else
      layer_2.y = -layer_1.height
      layer_2.x = layer_1.oriX
    end
    layer_2.oriY = layer_1.y
  elseif props.direction == "right" then
    layer_1.x = 0 + marginX
    layer_1.y = layer_1.oriY
    layer_1.oriX = layer_1.x
    if props.distance > 0 then
      layer_2.x =  -layer_1.width + props.distance
      layer_2.y = layer_1.oriY
    else
      layer_2.x =  layer_1.x - layer_1.width
      layer_2.y = layer_1.oriY
    end
    layer_2.oriX = layer_1.x
  elseif props.direction == "left" then
    layer_1.x = 0 - marginX
    layer_1.y = layer_1.oriY
    layer_1.oriX = layer_1.x
    if props.distance > 0 then
      layer_2.x = layer_1.width + props.distance
      layer_2.y = layer_1.oriY
    else
      layer_2.x = layer_1.x + layer_1.width
      layer_2.y = layer_1.oriY
    end
    layer_2.oriX = layer_1.x
  end
  layer_1.infinityLayer = layer_2
  layer_1.enterFrame = infinityBackHandler
  layer_2.enterFrame = infinityBackHandler

  -- print(layer_1.x, layer_1.width)
  -- print(layer_2.x, layer_2.width)
  -- layer_2.alpha = 0.5
  -- display.newRect(display.contentCenterX, 400, 570, 2)
  -- display.newCircle(layer_1.x, layer_1.y, 10)
end
--

function M.addEventListener(layer_1)
   Runtime:addEventListener("enterFrame", layer_1)
   Runtime:addEventListener("enterFrame", layer_1.infinityLayer)
end
---
function M.removeEventListener(layer_1)
  Runtime:addEventListener("enterFrame", layer_1)
  Runtime:addEventListener("enterFrame", layer_1.infinityLayer)
end

return M
