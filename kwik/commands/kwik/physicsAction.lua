-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
function _M:applyForce(obj, xfor, yfor)
   obj:applyForce(xfor, yfor, obj.x, obj.y)
end
--
function _M:bodyType(obj, btype)
    obj.bodyType = btype
end
--
function _M:invertGravity(obj, xgra)
   obj.gravityScale = xgra
end
--
return _M