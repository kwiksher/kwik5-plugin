local M = {}
local Application = require(kwikGlobal.ROOT.."controller.Application")
local Navigation = require("custom.components.page_navigation")
local composer = require("composer")
--
function M:autoPlay(ptrans, delay, _time)
  local options = {}
  local app = Application.get()
  if ptrans and ptrans ~="" then
    options =  { effect = ptrans,  time= _time}
 end
 app:autoPlay(delay, options)
end

function M:autoPlayCancel()
  local app = Application.get()
  app:autoPlayCacnel()
end

--
function M:showHideNavigation()
  if not Navigation.isVisible then
     Navigation.show()
  else
     Navigation.hide()
  end
end--
--
function M:reloadPage(canvas)
	if canvas then
   app.reloadCanvas = 0
	end
	composer.gotoScene("custom.commands.page_reload")
end
--
function M:gotoPage(pageName, effect, delay, duration)
  local app = Application.get()
  local options = {}
  local scene = app.scene.UI.page
  if pageName == "previous" then
    for i, v in next, app.props.scenes do
      if v == self.scene.UI.page then
         if i == 1 then
          scene = app.props.scenes[#app.props.scenes]
         else
          scene = app.props.scenes[i-1]
         end
         break
      end
    end
  elseif pageName == "next" then
    for i, v in next, app.props.scenes do
      if v == self.scene.UI.page then
         if i == #app.props.scenes then
          scene = app.props.scenes[1]
         else
          scene = app.props.scenes[i+1]
         end
         break
      end
    end
  else
    scene = pageName
  end
  ---
  local myClosure_switch= function()
      -- if nil~= composer.getScene("views.page0"..pnum.."Scene") then
      --    composer.removeScene("views.page0"..pnum.."Scene", true)
      -- end
      if effect and effect ~="" then
         options =  { effect = effect,  time= duration}
      end
      app:showview("components"..scene..".index", options)
  end
  if delay > 0 then
    local t = timer.performWithDelay(delay, myClosure_switch, 1)
    table.insert(app.scene.UI.timers, t)
  else
    myClosure_switch()
  end
end
--
return M