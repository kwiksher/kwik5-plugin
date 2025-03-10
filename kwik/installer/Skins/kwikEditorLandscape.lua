------------------------------------------------------------------------------
--
-- This file is part of the Corona game engine.
-- For overview and more information on licensing please refer to README.md
-- Home page: https://github.com/coronalabs/corona
-- Contact: support@coronalabs.com
--
------------------------------------------------------------------------------

-- simulator =
-- {
-- 	device = "ios-phone",
-- 	screenOriginX = 85,
-- 	screenOriginY = 77,
-- 	screenWidth = 1920,
-- 	screenHeight = 1080,
-- 	safeScreenInsetTop = 44 * 3,
-- 	safeScreenInsetLeft = 0 * 3,
-- 	safeScreenInsetBottom = 34 * 3,
-- 	safeScreenInsetRight = 0 * 3,
-- 	safeLandscapeScreenInsetTop = 0 * 3,
-- 	safeLandscapeScreenInsetLeft = 44 * 3,
-- 	safeLandscapeScreenInsetBottom = 21 * 3,
-- 	safeLandscapeScreenInsetRight = 44 * 3,
-- 	iosPointWidth = 375,
-- 	iosPointHeight = 812,
-- 	deviceImage = "iPhoneX.png",
-- 	displayManufacturer = "Apple",
-- 	displayName = "kwik Editor",
-- 	screenDressing = "iPhoneXScreenDressing.png",
-- 	statusBarDefault = "iPhoneXStatusBarBlack.png",
-- 	statusBarTranslucent = "iPhoneXStatusBarWhite.png",
-- 	statusBarBlack = "iPhoneXStatusBarBlack.png",
-- 	statusBarLightTransparent = "iPhoneXStatusBarWhite.png",
-- 	statusBarDarkTransparent = "iPhoneXStatusBarBlack.png",
-- 	windowTitleBarName = "Kwik Editor",
-- 	defaultFontSize = 17 * 3,		-- Converts default font point size to pixels.
-- }

simulator =
{
	device = "desktop-1920x1080",
	screenOriginX = 0,
	screenOriginY = 0,
	screenWidth = 590,
	screenHeight = 960,
	deviceImage = nil,
	displayManufacturer = "",
	displayName = "Kwik Landscape",
	supportsScreenRotation = false,
	windowTitleBarName = "Kwik Landscape Editor"
}
