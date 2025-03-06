-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
local composer = require("composer")
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			local function onSystemEvent(event)
			    local quitOnDeviceOnly = true
			    if quitOnDeviceOnly and system.getInfo("environment")=="device" then
			       if (event.type == "applicationSuspend")  then
			          if (system.getInfo( "platform" ) == "Android")  then
			              native.requestExit()
			          else
			              if nil~= composer.getScene("views.page01Scene") then
                      print("=== suspend remove page01Scene === ")
			                composer.removeScene("views.page01Scene", true)
			              end
			              print("==== suspend =====")
    			          composer.gotoScene("views.page01Scene")
			          end
			       end
			    end
			end
			Runtime:addEventListener("system", onSystemEvent)
		end
	end
	return command
end
--
return _Command