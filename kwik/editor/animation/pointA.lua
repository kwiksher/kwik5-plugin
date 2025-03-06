local M = {}
M.name = ...
M.weight = 6
local parent,  root = newModule(M.name)
local dragger = require(kwikGlobal.ROOT.."extlib.com.gieson.dragger")
local popup         = require(parent.."popup")

M.x = display.contentCenterX
M.y = display.contentCenterY
-- M.ptAcolor = {255/255, 7/255, 17/255, 25/255}
M.ptAcolor = {0/255, 178/255, 255/255, 255/255}

M.ptAtext = "A"

local Props = {
  popup 			= popup,
  ptTextFont = "Helvetica-Bold",
  ptTextSize = 18,
  ptTextColor = {255, 255, 255, 255},
}

function M:setBodyName (name)
  popup.bodyName = name
end

function M:setActiveEntryObjs(objX, objY)
  self.activeEntryX = objX
  self.activeEntryY = objY
end

function M:setActiveEntry(objX, objY)
  -- print("@@@setActtiveEntry", objX)
  popup.activeEntryX = objX
  popup.activeEntryY = objY
end

function M:setValueXY(x, y, name)
  self.group.alpha = 1
  self.group.x = x
  self.group.y = y
  self.oriX = x
  self.oriX = y
end
---
function M:setValue(objA)
  if objA == nil then
    self.group.alpha = 0
  else
    -- local x,y = objA:localToContent(objA.x, objA.y)
    local x,y = objA.x, objA.y
    self.group.alpha = 1
    self.group.x = x
    self.group.y = y
    self.oriX = x
    self.oriX = y
    self.x = x
    self.y = y
    -- print(self.name, x, y)
  end
end
--
function M:init(UI, x, y, width, height)
  self.x = x or self.x
  self.y = y or self.y
  self.width = width or self.width
  self.height = height or self.height
end
--
function M:create(UI)
    -- print("create", self.name)
    if self.x == nil then return end
    --
    self.objs = {}
    self.group = display.newGroup()
    UI.sceneGroup:insert(self.group)
    UI.editor.pointGroup = self.group

    local ptAdot = display.newCircle(0, 0, 15)
    ptAdot:setFillColor(unpack(self.ptAcolor))
    local ptAlabel = display.newText(self.ptAtext, 0, 0, Props.ptTextFont,
                                     Props.ptTextSize)
    ptAlabel:setTextColor(unpack(Props.ptTextColor))

    ptAlabel.x = 1.5
    ptAlabel.y = 0
    table.insert(self.objs, ptAdot)
    table.insert(self.objs, ptAlabel)

    local ptA = dragger:newDragger{
        img = self.group,
        callback = function(x, y)
          if self.activeEntryX then -- for animation
            popup.activeEntryX = self.activeEntryX
            popup.activeEntryY = self.activeEntryY
          end
          popup:onMove(self, x, y)
        end,
        popup = Props.popup
    }
    self.group:insert(ptAdot)
    self.group:insert(ptAlabel
  )
    --self.group:translate(display.contentCenterX-100, display.contentCenterY)
    self.group.ptA = ptA
    self.group.x = display.contentCenterX + self.x
    self.group.y = display.contentCenterY + self.y
end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy()
  if self.objs then
    for i, obj in next, self.objs do
      if obj.removeSelf then
        obj:removeSelf()
      end
    end
  end
  self.objs = nil
end

--
function M:toggle()
  -- print("@ toggle")
  for i, obj in next, self.objs do
   obj.isVisible = not obj.isVisible
  end
end

function M:show()
  -- print("@ show", self.group.x, self.group.y)
  for i, obj in next, self.objs or {} do
    obj.isVisible = true
  end
end

function M:hide()
  -- print("@ hide")
  for i, obj in next, self.objs or {} do
    obj.isVisible = false
  end
end


return M
