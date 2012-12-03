-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-- include Corona's "widget" library
local widget = require "widget"
local TwitterManager = require( "Twitter" )

--------------------------------------------


-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
--	if 	connectionStatus == "connected" then
--		local value = "I am about to play twitter blast"
--		TwitterManager.tweet(callback, value)
---	end
	-- go to maingame.lua scene
	storyboard.gotoScene( "maingame", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onTwitBtnRelease()	
	-- go to Linkup.lua scene
	storyboard.gotoScene( "smLinkup", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={0}, over={0} },
		default="media/btbg.png",
		over="media/btbg.png",
		font = native.systemFontBold,
		fontSize = 40,
		width=340, height=82,
		onRelease = onPlayBtnRelease
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x, playBtn.y = halfW, 300


	-- all display objects must be inserted into group
	group:insert( playBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	-- Check twitter
	print(connectionStatus)


	currentScene = storyboard.getCurrentSceneName()
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	if 	connectionStatus ~= "connected" then
		-- connect Twitter
		twitBtn = widget.newButton{
			label="Connect SM",
			labelColor = { default={0}, over={0} },
			default="media/btbg.png",
			over="media/btbg.png",
			font = native.systemFontBold,
			fontSize = 40,
			width=340, height=82,
			onRelease = onTwitBtnRelease
		}
		twitBtn:setReferencePoint( display.CenterReferencePoint )
		twitBtn.x, twitBtn.y = halfW, 600

		group:insert( twitBtn )
	end
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene