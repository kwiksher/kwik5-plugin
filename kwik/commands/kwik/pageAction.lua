-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require(kwikGlobal.ROOT.."controller.Application")
local composer = require("composer")
local Navigation = require(kwikGlobal.ROOT.."extlib.kNavi")
--
function _M:autoPlay(curPage)
    if nil~= composer.getScene("views.page0"..(curPage+1).."Scene" ) then
    	composer.removeScene( "views.page0"..(curPage+1).."Scene"  , true)
    end
   composer.gotoScene( "views.page0"..(curPage+1).."Scene"  )
end
--
function _M:showHideNavigation()
  if (_K.kNavig.alpha == 0) then
     Navigation.show()
  else
     Navigation.hide()
  end
end--
--
function _M:reloadPage(canvas)
	if canvas then
   _K.reloadCanvas = 0
	end
	composer.gotoScene("extlib.page_reload")
end
--
--
function _M:gotoPage(pnum, ptrans, delay, _time)
  local myClosure_switch= function()
      if nil~= composer.getScene("views.page0"..pnum.."Scene") then
          composer.removeScene("views.page0"..pnum.."Scene", true)
        end
      if ptrans and ptrans ~="" then
         composer.gotoScene( "views.page0"..pnum.."Scene", { effect = ptrans,  time= _time} )
      else
         composer.gotoScene( "views.page0"..pnum.."Scene" )
      end
  end
  if delay > 0 then
    _K.timerStash.pageAction = timer.performWithDelay(delay, myClosure_switch, 1)
  else
    myClosure_switch()
  end
end
--
return _M