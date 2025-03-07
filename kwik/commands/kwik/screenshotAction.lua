local M = {}
local json    = require('json')
local App = require("Application")
local needle = "Storage"
-- Helper function that determines if a value is inside of a given table.
local function isValueInTable( haystack, needle )
    assert( type(haystack) == "table", "isValueInTable() : First parameter must be a table." )
    assert( needle ~= nil, "isValueInTable() : Second parameter must be not be nil." )
    for key, value in pairs( haystack ) do
        if ( value == needle ) then
            return true
        end
    end
    return false
end
-- Called when the user has granted or denied the requested permissions.
local function permissionsListener( event, deferred )
    -- Print out granted/denied permissions.
    print( "permissionsListener( " .. json.prettify( event or {} ) .. " )" )
    -- Check again for camera (and storage) access.
    local grantedPermissions = system.getInfo("grantedAppPermissions")
    if ( grantedPermissions ) then
        if ( not isValueInTable( grantedPermissions, needle ) ) then
            print( "Lacking storage permission!" )
            deferred:reject()
        else
            deferred:resolve()
        end
    end
end
function checkPermissions()
    local deferred = Deferred()
    if ( system.getInfo( "platform" ) == "android" and system.getInfo( "androidApiLevel" ) >= 23 ) then
        local grantedPermissions = system.getInfo("grantedAppPermissions")
        if ( grantedPermissions ) then
            if ( not isValueInTable( grantedPermissions, needle ) ) then
                print( "Lacking storage permission!" )
                native.showPopup( "requestAppPermission", { appPermission={needle}, listener = function(event) permissionListener(event, deferred) end} )
            else
                deferred:resolve()
            end
        end
    else
        if  media.hasSource( media.PhotoLibrary ) then
            deferred:resolve()
        else
            deferred:reject()
        end
    end
    return deferred:promise()
end
---------------------
function M:init(UI)
  self.props = App.get().props
	if self.cam_shutter == nil then
	  self.cam_shutter = audio.loadSound(self.props.audioDir.."shutter.mp3", self.props.systemDir )
	end
end
--
function M:didShow(UI)
  self.sceneGroup = UI.sceneGroup
end
--
function M:take(title, pmsg, shutter, hideLayers)
	checkPermissions()
    :done(function()
        if shutter then
            audio.play(self.cam_shutter, {channel=31})
        end
        if hideLayers then
            for i=1, #hideLayers do
              local layer = self.sceneGroup[hideLayers[i]]
              layer.alphaBeforeScreenshot = layer.alpha
              layer.alpha = 0
            end
        end
            --
        local screenCap = display.captureScreen( true )
        local alert = native.showAlert(title, pmsg, { "OK" } )
        screenCap:removeSelf()
        if hideLayers then
            for i=1, #hideLayers do
              local layer = self.sceneGroup[hideLayers[i]]
              layer.alpha = layer.alphaBeforeScreenshot
            end
        end
    end)
	:fail(function()
	    print("fail")
	    native.showAlert( "Corona", "Request permission is not granted on "..system.getInfo("model"), { "OK" } )
    end)
end
--
function M:didHide(UI)
	if self.cam_shutter then
		audio.stop(31)
	end
end
--
function M:destroy(UI)
		audio.dispose(self.cam_shutter)
		self.cam_shutter = nil
end
--
return M