local name = ...
local parent,root = newModule(name)
local M = {name = name, views = {
  "index", -- this creates actionIcon button
  "selector", -- context:mapCommands "selectAction", "selectActionCommand"
  "actionTable", -- lists actions in a page
  "actionCommandTable",
  "actionCommandPropsTable",
  "commandView",
  "commandbox", -- animation.play, pause, ..
  "buttons",
  "actionCommandButtons"
}}

M.weight = 1
M.x = 54
M.y = -2
---
local util    = require(kwikGlobal.ROOT.."lib.util")

local muiIcon = require(kwikGlobal.ROOT.."components.mui.icon").new()
local mui     = require("materialui.mui")
local muiData = require("materialui.mui-data")

local models         = require(kwikGlobal.ROOT.."template.commands.model").menu
local controller     = require(parent.."controller.index")
local commandView    = require(parent.."commandView")
local actionCommandTable = require(parent.."actionCommandTable")
local selectbox      = require(root.."parts.selectbox"):newInstance()
local toolbar        = require(root .."parts.toolbar")
-- print("@@@@@", root)
local selectors      = require(root.."parts.selectors")
local picker = require(kwikGlobal.ROOT.."editor.picker.name")
-- --
local bt = require(kwikGlobal.ROOT..'editor.controller.BTree.btree')
local tree = require(kwikGlobal.ROOT.."editor.controller.BTree.selectorsTree")


selectbox.name = "actionName"
selectbox.create = function(UI) end -- see createSelectbox below

---[[


function M:init(UI)
end



M.commandMap = {}
  -- local acton = {"command":"audio.play", "params":{
  --   "target" : "bgm",
  --   "type" : "",
  --   "channel" : "",
  --   "repeatable" : true,
  --   "delay" : "",
  --   "loop" : -1,
  --   "fade" : "",
  --   "volume" : "",
  --   "trigger" : "eventTwo"
  -- }}



function M.iconHander()
  local self = M
  self.isVisible = not self.isVisible
  local UI = self.UI
    if self.isVisible then

      tree:setConditionStatus("select layer", bt.FAILED, false)
      -- tree:setActionStatus("load layer", bt.RUNNING, true)
      -- tree:setConditionStatus("select props", bt.FAILED)

      selectors.componentSelector:onClick(self.isVisible, "actionTable")

      --UI.editor.actionStore:set(UI.scene.model.commands)

      -- self.UI.scene.app:dispatchEvent(
      --   {
      --     name = "editor.action.selectAction",
      --     UI = self.UI,
      --   }
      -- )


      self:show()
    else
      UI.editor.actionStore:set{value = {}}
      self:hide()
    end
end




local buttons            = require(kwikGlobal.ROOT.."editor.action.buttons")
local partsButtons       = require(kwikGlobal.ROOT.."editor.parts.buttons")
local classProps         = require(kwikGlobal.ROOT.."editor.parts.classProps")
local classPropsPhysics  = require(kwikGlobal.ROOT.."editor.physics.classProps")
local actionTable = require(kwikGlobal.ROOT.."editor.action.actionTable")
--
M.otherButtons = {}

function M:addToogleButton(mod)
  self.otherButtons = {}
  self.otherButtons[1] = mod
end

function M:showActionTable(actionbox, isNew)
  actionTable.actionbox = actionbox
  if isNew then
    self.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      action = {},
      isNew = true,
      UI = self.UI
    }

    classProps.origVisible = classProps.isVisible
    classProps:hide()

    classPropsPhysics.origVisible = classPropsPhysics.isVisible
    classPropsPhysics:hide()

    if classProps.type == "editor.timer.index" then
      for i, v in next, self.otherButtons do
        v:hide()
      end
    else
      partsButtons:hide()
    end
  else
    ---
    --- there were multiple instances of actionbox from selectAudio, actionTable and sync's word action
    ---
    actionTable:show()

    local UI = self.UI
    if not self.isVisible then
      UI.editor.actionStore:set{value=UI.scene.model.commands, isActiveProp=true}
      self:show()
      buttons:hide()
    else
      -- UI.editor.actionStore:set({})
      -- self:hide()
    end
  end
end

function M:createIcon(UI)
  local actionIcon = muiIcon:create {
    icon     = {"actions_over", "actions_over","actions_over"},
    text     = "",
    name     = "action-icon",
    x        = self.x,
    y        = self.y,
-- y        = (display.actualContentHeight - display.contentHeight)/2 -2,
    width    = 22,
    height   = 22,
    fontSize = 16,
    listener = self.iconHander,
    fillColor = {1.0}
  }
  UI.editor.actionIcon = actionIcon
  -- actionIcon.isVisible = false
  UI.editor.rootGroup:insert(actionIcon)
end

function M:createSelectbox(UI)
  -- UI.editor.viewStore = self.group -- used in selecbox:create()
  selectbox:init(UI, self.x + 22, self.y+24, 96, 22)
  selectbox:setValue(
    {
      {name="new-action", class="action"},
      -- {name="new-action2", class="action"}
    }
    , 1)
    selectbox:create(UI)
    -- selectbox:hide()
  -- selectbox.scrollView:scrollToPosition{y=-22}
  self.selectbox = selectbox

  self.selectbox.classEditorHandler = function(decoded, index)
  end

  self.selectbox.useClassEditorProps = function()
    return {}
  end
end


--
function M:create(UI)
  -- if self.group then return end
  self.UI = UI
  self.group = display.newGroup()
  --
  controller:init(UI, self.commandMap, selectbox)
  -- print("create", self.name)
  -----------------------------------------
  self:createIcon(UI)
  -----------------------------------------
  self:createSelectbox(UI)
  -----------------------------------------

  -- self:createCommandview()
  commandView:init(UI, actionCommandTable.left, 22, models, self.commandMap)

  UI.editor.actionEditor = self
  --
  self:hide()
  -- self:show()

  if system.orientation == "portrait" then
    local delta_x = 400
    self.group:translate(delta_x, 0)
    -- if self.group.propsTable then
    --   self.group.propsTable:translate(delta_x, 0)
    -- end
  else
    local delta_x = 400
    self.group:translate(delta_x/2, 0)
  end

  buttons:hide()

end

-- function M:createCommandview()
--   local scrollView = commandView:createTable(models, self.commandMap, self.group, self.UI)
--   self.group:insert(scrollView)
--   self.group.commandView = scrollView
--   self.UI.editor.viewStore.commandView = scrollView
--   -----------------------------------------
-- end


function M:commandViewHandler(name, selectLayer)
  if commandView.activeEntry == name then
    commandView.activeEntry = nil
  else
    commandView.activeEntry = name
  end
  local group = self.UI.editor.rootGroup
  group.commandView:removeSelf()
  commandView:createCommandview()
end
-----------------------------------------
function M:show(editor)
  controller:show(editor)
  buttons:show()
  self.isVisible = true
  -- picker:show()
end

function M:hide(cancel)
  controller:hide(cancel)
  --self.isVisible = false
  picker:hide()
end

function M:hideCommandPropsTable()
  local UI = self.UI
  UI.editor.viewStore.commandbox:hide()
  UI.editor.viewStore.actionCommandPropsTable:hide()
  UI.editor.viewStore.actionCommandButtons.lastVisible = false
  UI.editor.viewStore.actionCommandButtons:hide()

end
--
function M:didShow(UI)
  self.selectbox:didShow(UI)
end
--
function M:didHide(UI)
  if self.selectbox then
    self.selectbox:didHide(UI)
  end
end
--
function M:destroy(UI)
  if self.selectbox then
   -- self.selectbox:destroy(UI)
  end
end

--]]

--
return M
