-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _K            = require "controller.Application"
local _M = {}
--		obj:showHide("objB", false)
function _M:editImage(obj, mx, my, sw, sh, fh, fv, ro)
   local _mx, _my  = _K.ultimatePosition(mx, my)
   if mx then
        obj.x = _mx
   end
   if my then
        obj.y = _my
   end
   if sw then
        obj.xScale = sw
   end
   if sh then
       obj.yScale = sh
   end
   if fh then
       obj.xScale = obj.xScale * -1
   end
   if fv then
       obj.yScale = obj.yScale * -1
   end
   if ro then
       obj.rotation = ro
   end
end
--
return _M