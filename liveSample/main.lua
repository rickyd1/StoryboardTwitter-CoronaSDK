-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"
storyboard.isDebug = true
storyboard.purgeOnSceneChange = true
-- Load Twitter
TwitterManager = require( "Twitter" )


-----------------------------------------------------------------------------------------
-- Setup Twitter
-----------------------------------------------------------------------------------------
-- load twitter status
function createStatusMessage( message, x, y )
	-- Show text, using default bold font of device (Helvetica on iPhone)
	local textObject = display.newText( message, 0, 0, native.systemFontBold, 24 )
	textObject:setTextColor( 255,255,255 )

	-- A trick to get text to be centered
	local group = display.newGroup()
	group.x = x
	group.y = y
	group:insert( textObject, true )

	-- Insert rounded rect behind textObject
	local r = 10
	local roundedRect = display.newRoundedRect( 0, 0, textObject.contentWidth + 2*r, textObject.contentHeight + 2*r, r )
	roundedRect:setFillColor( 55, 55, 55, 190 )
	group:insert( 1, roundedRect, true )

	group.textObject = textObject
	return group
end



callback = {}

local statusMessage = createStatusMessage( "   Not connected  ")

-- Twitter Callbacks
function callback.twitterCancel()
	print( "Twitter Cancel" )
	statusMessage.textObject.text = "Twitter Cancel"
	statusIcon:setFrame( 4 )
	
	local scene = currentScene
	print(scene)
	if scene == 'smLinkup' then
		storyboard.gotoScene( "menu", "fade", 500 )
	end
end

function callback.twitterSuccess()
	print( "Twitter Success" )
	statusMessage.textObject.text = "Twitter Success"
	statusIcon:setFrame( 1 )
	local scene = currentScene
	print(scene)
	connectionStatus = "connected"
	if scene == 'smLinkup' then
		storyboard.gotoScene( "menu", "fade", 500 )
	end
end

function callback.twitterFailed()
	print( "Failed: Invalid Token" )
	statusMessage.textObject.text = "Failed: Invalid Token"
end


-----------------------------------------------------------------------------------------
-- Setup Stage
-----------------------------------------------------------------------------------------

-- background should appear behind all scenes
local background = display.newImageRect( "media/background.png", display.contentWidth, display.contentHeight )
background:setReferencePoint( display.TopLeftReferencePoint )
background.x, background.y = 0, 0

-- tab bar image should appear above all scenes
local tabBar = display.newImage( "media/tabbar.png" )
tabBar:setReferencePoint( display.TopLeftReferencePoint )
tabBar.x, tabBar.y = 0, 0

-- load status icon sprite
options =
{
    -- The params below are required

    width = 64,
    height = 64,
    numFrames = 4,

    -- The params below are optional; used for dynamic resolution support

    sheetContentWidth = 128,  -- width of original 1x size of entire sheet
    sheetContentHeight = 128  -- height of original 1x size of entire sheet
}

imageSheet = graphics.newImageSheet( "media/bird-sprite.png", options )

local sequenceData = {
	{ name = "normalThrow", frames={ 1,2,3,4 }, count=1, time=1200 }
}	
statusIcon = display.newSprite( imageSheet, sequenceData )
statusIcon:setReferencePoint( display.TopRightReferencePoint )
statusIcon.x = display.contentWidth
statusIcon.y = 0
statusIcon:play()
statusIcon:pause()
statusIcon:setFrame( 2 )


statusMessage:setReferencePoint( display.TopCenterReferencePoint )
statusMessage.x, statusMessage.y = 0.5*display.contentWidth, 0

-- put everything in the right order
local display_stage = display.getCurrentStage()
display_stage:insert( background )
display_stage:insert( storyboard.stage )
display_stage:insert( tabBar )
display_stage:insert( statusMessage )
display_stage:insert( statusIcon )
-- load menu screen
storyboard.gotoScene( "menu" )