-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K            = require "controller.Application"
--
function _M:startTimer(tname, delay, trigger, loop)
	_K.timerStash[tname] = timer.performWithDelay(delay*1000, trigger, loop )
end
--
function _M:pauseTimer(tname)
	timer.pause( _K.timerStash[tname])
end
--
function _M:resumeTimer(tname)
	timer.resume( _K.timerStash[tname])
end
--
function _M:createTimer(tname, delay, trigger, loop, params)
	_K.timerStash[tname] = timer.performWithDelay(delay*1000,
		function()
    Runtime:dispatchEvent({name=trigger, event=params.event, UI=params.UI})
		end , loop )
end
--
function _M:cancelTimer(tname)
	timer.cancel( _K.timerStash[tname])
end
--
return _M