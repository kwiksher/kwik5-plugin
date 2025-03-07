local current = ...
local parent,  root, M = newModule(current)
-- local parent = current:match("(.-)[^%.]+$")
-- local root = parent:sub(1, parent:len() - 1):match("(.-)[^%.]+$")

local json = require("json")
local bt = require(parent .. "controller.BTree.btree")
local tree = require(parent .. "controller.BTree.selectorsTree")
local util = require(kwikGlobal.ROOT.."lib.util")
local guides = require(parent .. "parts.guides")
M.clipboard = require(kwikGlobal.ROOT.."editor.clipboard")
local layerTools = require(parent .. "model").layerTools
local pageTools = require(parent .. "model").pageTools
local assetTool = require(parent .. "model").assetTool

M.actionViews = require(parent .. "action.index").views
local nanostores = require(kwikGlobal.ROOT.."extlib.nanostores.index")
local App = require(kwikGlobal.ROOT.."controller.Application")
local mui = require("materialui.mui")

local selectors = require(parent .. "parts.selectors")
local bookTable = require(parent .. "parts.bookTable")
local pageTable = require(parent .. "parts.pageTable")
local layerTable = require(kwikGlobal.ROOT.."editor.parts.layerTable")

--
-- print(current, parent ,root)
--
-- commonents[i].id like "animation" calls for view.animation
--

--
M.lastSelection = {book = "book", page = "page12"}
M.contextInit = false
M.storeInit = false

local gotodLastOn = false
local unitTestOn = false
local httpServerOn = false
local showPageName = true

M.viewStore = {}
--
-- editor is singleton
--
M.commands = {
  {name = "selectApp", btree = nil},
  {name = "selectBook", btree = "load book"},
  {name = "selectPage", btree = "load page"},
  {name = "selectLayer", btree = "load layer"},
  {name = "selectPageIcons", btree = nil},
  {name = "lockPage", btree = nil},
  -- {name="selectAction", btree=""},
  {name = "selectTool", btree = "editor component"},
  -- {name="selectActionCommand", btree=""}
  {name = "selectAudio", btree = "load audio"},
  {name = "selectGroup", btree = "load group"},
  {name = "selectTimer", btree = "load timer"},
  {name = "selectVariable", btree = "load variable"},
  {name = "selectJoint", btree = "load joint"}

  -- {name="selectVideo", btree="load video"},
}

-- connects with BTree ----
local BTMap = {}
for i = 1, #M.commands do
  if M.commands[i].btree then
    BTMap[M.commands[i].btree] = {eventName = "editor.selector." .. M.commands[i].name, name = M.commands[i].name}
  end
end
-- BTree calls this when activating actionNode
M.BThandler = function(name, status)
  -- print(debug.traceback())

  -- print("#BTHandler: dispathEvent")
  --  print("", name,  bt.getFriendlyStatus( nil,status ))
  local target = BTMap[name]
  -- print("", target)
  if target and M.UI then
    --print("", target.eventName)
    --local obj = M.UI.editor.rootGroup[target.name]
    local params = {
      name = target.eventName,
      UI = M.UI -- beaware UI is belonged to a page
      -- show = not obj.isVisible,
    }
    if tree.backboard then
      for k, v in pairs(tree.backboard) do
        -- print("", k, v)
        params[k] = v
      end
    end
    -- print("@@@", M.UI.scene.app.props.appName)
    M.UI.scene.app:dispatchEvent(params)
  end
  return bt.SUCCESS
end
--
-- See selects.lua selectorBase.new, store = "xxxTable"
--
M.models = {
  "selectors",
  "bookTable",
  "pageTable",
  "layerTable",
  "propsTable",
  "propsButtons",
  "toolbar"
  -- "audioTable",
  -- "groupTable",
  -- "timerTable",
  -- "variableTable"
}


M.views = nil
M.rootGroup = nil


--
-- this returns a tool obj
function M:getClassModule(class)
  local v = self.classMap[class:lower()] or class
  -- for k, v in pairs(self.editorTools) do print(k) end
  local mod = self.editorTools[v]
  -- print("@@@@", v, mod)
  if mod == nil then
    -- print("@@@@ Error to find", v)
    return self.editorTools["editor.parts.baseTable-" .. v]
  end
  return mod
end

function M:getClassFolderName(class)
  -- print(class)
  return self.classMap[class:lower()]
end

function M:initStores()
  -- print("### initStores")
  --
  -- selectors.lua will set values of each stores
  --
  self.bookStore = nanostores.createStore()
  self.pageStore = nanostores.createStore()
  self.layerStore = nanostores.createStore()
  self.layerJsonStore = nanostores.createStore()
  self.propsStore = nanostores.createStore()
  self.actionStore = nanostores.createStore()
  self.actionCommandStore = nanostores.createStore()

  self.assetStore = nanostores.createStore()
  self.labelStore = nanostores.createStore()
  self.actionCommandPropsStore = nanostores.createStore()
  self.groupLayersStore = nanostores.createStore()
  --
  self.audioStore = nanostores.createStore()
  self.groupStore = nanostores.createStore()
  self.timerStore = nanostores.createStore()
  self.variableStore = nanostores.createStore()
  self.jointStore = nanostores.createStore()
end
---
function M:init(UI)
  -- print("init")
  self.UI = UI
  if self.rootGroup then
    self:destroy(UI)
    self.rootGroup:removeSelf()
    self.rootGroup = nil
  end
  -- if self.views == nil then
  self.rootGroup = display.newGroup()
  self.views = {}
  self.classMap = {}
  self.assets = {}

  --
  if kwikGlobal.showPageName then
    local options = {
      parent = sceneGroup,
      text = UI.page,
      font = native.systemFont,
      fontSize = 20,
      align = "center",
      x = display.contentCenterX,
      y = display.contentCenterY - 360/2,
    }
    local pageText = display.newText(options)
    self.rootGroup:insert(pageText)
  end

  --
  local app = App.get()
  if app.editorContextInit == nil then
    -- print("init", app.props.appName, app)
    for i = 1, #self.commands do
      app.context:mapCommand(
        "editor.selector." .. self.commands[i].name,
        "editor.controller.selector." .. self.commands[i].name
      )
    end
    app.editorContextInit = true
  end
  --
  for i = 1, #self.models do
    self.views[i] = require(parent .. "parts." .. self.models[i])
  end
  for i = 1, #self.actionViews do
    -- print(parent.."action."..self.actionViews[i])
    self.views[#self.views + 1] = require(parent .. "action." .. self.actionViews[i])
  end
  -- Here linking toolbar-xx with view.animation, ...
  self.editorTools = {}
  ------
  -- layer tool
  for i = 1, #layerTools do
    if layerTools[i].id then
      local module = require(parent .. layerTools[i].id .. ".index")
      module.id = layerTools[i].id
      module.name = module.name or layerTools[i].id
      self.views[#self.views + 1] = module
      self.editorTools[layerTools[i].id] = module
      for j = 1, #layerTools[i].tools do
        if layerTools[i].tools[j].id then
          -- Aditional editor for particles
          self.classMap[layerTools[i].tools[j].name:lower()] = layerTools[i].id .. "." .. layerTools[i].tools[j].id
          -- print("@", layerTools[i].tools[j].name:lower(), layerTools[i].id.."."..layerTools[i].tools[j].id)
          -- print(parent..layerTools[i].id.."."..layerTools[i].tools[j].id..".index")
          --
          local module = require(parent .. layerTools[i].id .. "." .. layerTools[i].tools[j].id .. ".index")
          module.name = module.name or layerTools[i].id .. "." .. layerTools[i].tools[j].id
          self.views[#self.views + 1] = module
          self.editorTools[layerTools[i].id .. "." .. layerTools[i].tools[j].id] = module
        else
          -- print("@", layerTools[i].tools[j].name:lower(), layerTools[i].id)
          self.classMap[layerTools[i].tools[j].name:lower()] = layerTools[i].id
        end
        --print(layerTools[i].tools[j].name, layerTools[i].id)
      end
    end
  end
  -----
  -- page tool
  for k, v in pairs(pageTools) do
    if v.id then
      -- print("@@@", parent..v.id..".index")
      local module = require(parent .. v.id .. ".index")
      module.name = module.name or v.id
      self.views[#self.views + 1] = module
      self.editorTools["editor.parts.baseTable-" .. v.id] = module
    end
  end

  ------
  -- asset tool
  print("@@@@@@@@@@",parent .. assetTool.id .. ".index")
  local mod = require(parent .. assetTool.id .. ".index")
  mod.name = mod.name or assetTool.id
  self.views[#self.views + 1] = mod
  self.editorTools["editor.parts.baseTable-" .. assetTool.id] = mod

  if self.storeInit == false then
    self:initStores()
    self.storeInit = true
  end
  --
  UI.editor = self
  for i = 1, #self.views do
    -- print("init", self.views[i].name)
    self.views[i]:init(UI)
  end
  --
  -- display.setDefault( "fillColor", 1, 0, 0 )
  -- display.setDefault( "background", 1, 1, 1, 0.01 )
  mui.init(nil, {parent = self.rootGroup, useSvg = true})

  tree:init(self.BThandler)
  tree:setConditionStatus("select book", bt.SUCCESS, true)
  tree:tick()

  -- end
end
--
function M:setCurrnetSelection(layer, class, _type)
  -- print("##### setCurrentSelection", class)
  -- print(debug.traceback())
  self.currentLayer = layer or ""
  self.currentClass = class or ""
  self.currentType = _type
end
--
function M:create(UI)
  -- print("####### editor create")
  UI.editor = self
  for i = 1, #self.views do
    self.views[i]:create(UI)
  end
  guides:create(UI)
end
--
function M:runTest(UI)
  timer.performWithDelay(
    500,
    function()
      require("test.index").run {
        selectors = selectors,
        UI = UI,
        bookTable = bookTable,
        pageTable = pageTable,
        layerTable = layerTable,
        actionTable = actionTable
      }
      if UI.testCallback then
        UI.testCallback()
      end
    end
  )
end


function M:runServer(UI)
  local server = require(kwikGlobal.ROOT.."server.index")
  server.run {
    selectors = selectors,
    UI = UI,
    bookTable = bookTable,
    pageTable = pageTable,
    layerTable = layerTable
  }
end

function M:showPageView()
  -- print("@@@@ showPageView")
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
end

function M:gotoLastSelection(_props)
  local UI = self.UI
  local props = {book = "book", page = "page1", selections = {layer = "cat", class = "linear"}}
  -- Path for the file to read
  local path = system.pathForFile("kwik.json", system.ApplicationSupportDirectory)
  -- Open the file handle
  local file, errorString = io.open(path, "r")
  if file == nil then
    print("gotoLastSelection no file")
    return
  end
  --
  --
  if _props then
    -- Error occurred; output the cause
    props = _props
  else
    ---
    --- remove it
    -- local result, reason = os.remove( path )
    -- if result then
    --   print( "File removed" )
    -- else
    --   print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
    -- end
    -- Read data from file
    local contents = file:read("*a")
    -- Output the file contents
    print( "Contents of " .. path .. "\n" .. contents )
    -- Close the file handle
    io.close(file)
    props = json.decode(contents)
    -- check it
    if props.page == nil or not util.isDir(props.book .. "/components/" .. props.page) then
      print("gotoLastSelection page is null", "App/" .. (props.book or "") .. "/components/" .. (props.page or ""))
      props.book = nil
    end
  end

  local helper = require("test.helper")
  local bookTable = require(kwikGlobal.ROOT.."editor.parts.bookTable")
  local pageTable = require(kwikGlobal.ROOT.."editor.parts.pageTable")
  local layerTable = require(kwikGlobal.ROOT.."editor.parts.layerTable")
  local Shapes = require(kwikGlobal.ROOT.."editor.controller.index").Shapes

  helper.init({bookTable = bookTable, pageTable = pageTable, layerTable = layerTable})
  --
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }

  UI.editor.lastSelection = {book = props.book, page = props.page}
  if props.book == nil or props.book:len() == 0 then
    print("gotoLastSelection book is null")
    return
  end
  --
  local obj = helper.selectBook(props.book)
  if obj then
    bookTable.commandHandler(obj, {phase = "ended"}, true)
    timer.performWithDelay(
      1000,
      function()
        pageTable.commandHandler({page = props.page}, {}, true)
        --[[
      if props.selections and props.selections[1] then
        selectors.componentSelector.iconHander()
        selectors.componentSelector:onClick(true,  "layerTable")
        if props.selections[1].name == "action pasted" then
          helper.selectIcon("action")
        elseif props.selections[1].name == "pasted" then
          local class = props.selections[1].class
          if class == "audio" then
            selectors.componentSelector:onClick(true,  "audioTable")
          elseif class == "group" then
            selectors.componentSelector:onClick(true,  "groupTable")
          elseif class == "timer" then
            selectors.componentSelector:onClick(true,  "timerTable")
          elseif class == "variable" then
            selectors.componentSelector:onClick(true,  "variableTable")
          elseif class == "joint" then
            selectors.componentSelector:onClick(true,  "jointTable")
          elseif class == "page" then
            selectors.projectPageSelector:onClick(true)
          end
        elseif Shapes[props.selections[1].class] then
          helper.selectLayer(props.selections[1].name)
        else
          helper.selectLayer(props.selections[1].name, props.selections[1].class)
        end
      end
      --]]
      end
    )
  else
    print("gotoLastBook obj is null")
  end
  return false
end

function M:didShow(UI)
  self.UI = UI
  UI.editor = self
  for i = 1, #self.views do
    self.views[i]:didShow(UI)
  end

  --
  -- default or reload
  --
  UI.editor.currentBook = UI.book
  -- UI.editor.currentPage = "page2"
  local showComponentSelector = true
  local showProjectSelector = true
  if showProjectSelector then
    -- UI.scene.app:dispatchEvent {
    --   name = "editor.selector.selectApp",
    --   UI = UI
    --   -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
    --   -- useTinyfiledialogs = false -- default
    -- }
    -- bookTable.commandHandler({book="bookFree"},nil,  true)
    -- UI.scene.app:dispatchEvent {
    --   name = "editor.selector.selectBook",
    --   UI = UI,
    --   book = "bookFree"
    -- }
    selectors.projectPageSelector:show()
    selectors.projectPageSelector:onClick(true)
  elseif showComponentSelector then
    if not self.isReloaded then
      self.isReloaded = true
    ----------------------------
    --self:gotoLastSelection() -- self.lastSelection
    end
  end

  if kwikGlobal.gotoLastBook then
    self:gotoLastSelection() -- self.lastSelection
    kwikGlobal.gotoLastBook = false
  end

  if kwikGlobal.unitTest then
    self:runTest(UI)
  end
  if kwikGlobal.httpServer then
    self:runServer(UI)
  end
  -- UI.editor.rootGroup:dispatchEvent{name="labelStore",
  --   currentBook= UI.editor.currentBook,
  --   currentPage= UI.page,
  --   currentLayer = UI.editor.currentayer}
  -- print ("------------ UI.editor.rootGroup ---------")
  -- for k, v in pairs(UI.editor.rootGroup) do print("", k) end
  -- print ("------------ UI.editor.viewStore ---------")
  -- for k, v in pairs(UI.editor.viewStore) do print("", k) end
end
--
-- didHide is called back from showView gotoScene
function M:didHide(UI)
  UI.editor = self
  if self.views then
    for i = 1, #self.views do
      self.views[i]:didHide(UI)
    end
  end
end
--
-- destroy is not called from gotoScene because of recycle?
function M:destroy(UI)
  --UI.editor = self
  --  print("destroy")
  if self.views then
    for i = 1, #self.views do
      -- print(self.views[i].name)
      self.views[i]:destroy(UI)
    end
  end
  self.views = nil
  ---
  if self.rootGroup then
    self.rootGroup:removeSelf()
    self.rootGroup = nil
  end
end
--
-- print(debug.traceback())
return M
