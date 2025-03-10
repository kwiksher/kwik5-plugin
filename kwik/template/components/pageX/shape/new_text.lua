-- $weight={{weight}}
--
local parent,root, M = newModule(...)
local app = require "controller.Application"
--
local layerProps = {
  name     = "{{name}}",
  x        = {{x}},
  y        = {{y}},
  width    =  {{width}},
  height    =  {{height}},
  xScale = {{xScale}},
  yScale = {{yScale}},
  anchorX = {{anchorX}},
  anchorY = {{anchorY}},
  rotation = {{rotation}},
  {{#fill}}
  color    = { {{r}}, {{g}}, {{b}}, {{a}} },
  {{/fill}}
  text     = "{{text}}",
  -- width    = nil, -- {{width}},
  font     = {{font}},
  fontSize = {{size}}, -- {{fontSize}}
  align    = "{{align}}",  -- Alignment parameter
  shapedWith    = "new_text"
}

M.layerProps = layerProps
--
function M:init(UI)
  --local sceneGroup = UI.sceneGroup
end
--
function M:create(UI)
  local layerProps = self.layerProps
  -- layerProps.x, layerProps.y = app.getCenter(layerProps.x, layerProps.y)

  local  obj = display.newText(layerProps)

  obj.name = layerProps.name
  if layerProps.color then
    obj:setFillColor(unpack(layerProps.color))
  end

  obj.anchorX = layerProps.anchorX or 0.5
  obj.anchorY = layerProps.anchorY or 0.5
  obj.rotation = layerProps.rotation or 0
  obj.shapedWith = layerProps.shapedWith

  obj.oldAlpha = 1

  obj.layerIndex = #UI.layers+1
  UI.layers[obj.layerIndex] = obj
  UI.sceneGroup:insert(obj)
  UI.sceneGroup[obj.name] = obj

end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function  M:destroy(UI)
end
--
function M:new(props)
  return self:newInstance(props, layerProps)
end
--
return M