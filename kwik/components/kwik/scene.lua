local M = {}
local App = require("Application")

local composer = require("composer")
composer.recycleOnSceneChange = true

M.new = function(sceneName, model)
    local scene = composer.newScene(sceneName)
    scene._composerFileName = nil
    local componentFolder = sceneName:gsub("scenes.", "components")
    scene.classType = "scenes." .. sceneName
    scene.UI = App.createUI(scene, model)
    scene.model = model
    ------------------------------------------------------------
    ------------------------------------------------------------
    function scene:create(event)
        if self.UI == nil then
          self.calssType = event.params.sceneProps.classType
          self.UI = event.params.sceneProps.UI
          self.model = event.params.sceneProps.model
          self.getCommands = event.params.sceneProps.getCommands
        end
        local sceneGroup = self.view
        if self.model.onInit then self.model.onInit(self) end
        self.UI:create(self, event.params)
        Runtime:dispatchEvent({name = "onRobotlegsViewCreated", target = self})
    end
    --
    function scene:show(event)
        local sceneGroup = self.view
        if event.phase == "will" then
            self.UI:willShow(self, event.params)
        elseif event.phase == "did" then
            self.UI:didShow(self, event.params)
        end
    end
    --
    function scene:hide(event)
        if event.phase == "will" then
            if event.parent then event.parent.UI:resume() end
            self.UI:didHide(self, event.params)
        elseif event.phase == "did" then
        end
    end
    --
    function scene:destroy(event)
        self.UI:destroy(self, event.params)
        Runtime:dispatchEvent({name = "onRobotlegsViewDestroyed", target = self})
    end
    --
    scene:addEventListener("create", scene)
    scene:addEventListener("show", scene)
    scene:addEventListener("hide", scene)
    scene:addEventListener("destroy", scene)
    --
    function scene:getCommands()
        local commands = {}
        -- local commands = {"initMenu","printStack",
        --    "layersList.select", "layersList.drag",
        --    "layerProps.new", "layerProps.update","layerProps.attachFile", "layerProps.drag"
        -- }
        local function iterator(layers)
            if type(layers) == "table" then
                for i = 1, #layers do
                    local layer = layers[i]
                    for name, value in pairs(layer) do
                        --print(name, #value)
                        -- print("", "string")
                        if value.commands then
                            for k, eventName in pairs(value.commands) do
                               -- print("", name .. "." .. eventName)
                                table.insert(commands,
                                             name .. "." .. eventName)
                            end
                        elseif value.types then
                            -- do nothing
                        else
                            if #value == 0 then
                                -- do nothing
                            else
                                iterator(value)
                            end
                            -- print("", value, parent)
                        end
                    end
                end
            end
        end
        -- for layers
        iterator(self.model.components.layers)
        for i=1, #self.model.commands do
            table.insert(commands, self.model.commands[i])
        end
        return commands
    end
    return scene

end

return M
