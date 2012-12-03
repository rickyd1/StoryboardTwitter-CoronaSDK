-----------------------------------------------------------------------------------------
--
-- Connect to SM
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Tweet the message
local function tweetit( event )
	local value = "My app is connected to twitter #cornasdk" 
	TwitterManager.tweet(callback, value)
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	currentScene = storyboard.getCurrentSceneName()
	local group = self.view	
	twitterButton = widget.newButton {
		id = "button1",
		default="media/btbg.png",
		over="media/btbg.png",
		label = "Connect Twitter",
		left = 380,
		top = 300,
		width=340, height=82,
		fontSize = 40,
		onRelease = tweetit
	}

	twitterButton.x = display.contentWidth / 2
	twitterButton.y = display.contentHeight - display.contentHeight / 3

	group:insert( twitterButton)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view		


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