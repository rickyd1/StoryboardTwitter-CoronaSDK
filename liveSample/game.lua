-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local scorer = require ("score")

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------


-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------
-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	audio.play(buttonSound)
	-- go to level1.lua scene
	storyboard.gotoScene( "maingame", "fade", 500 )
	
	return true	-- indicates successful touch
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- display a background image
	local background = display.newImageRect( "media/background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	-- display a background image
	local scoreboard = display.newImageRect( "media/gameover.png", 584, 371 )
	scoreboard:setReferencePoint( display.TopCenterReferencePoint )
	scoreboard.x, scoreboard.y = halfW, 110

	

	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( scoreboard )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	-- create a widget button (which will loads level1.lua on release)
	playAgainBtn = widget.newButton{
		label="Play Again",
		labelColor = { default={0}, over={0} },
		default="media/btbg.png",
		over="media/btbg.png",
		font = native.systemFontBold,
		fontSize = 40,
		width=340, height=82,
		onRelease = onPlayBtnRelease
	}
	playAgainBtn:setReferencePoint( display.CenterReferencePoint )
	playAgainBtn.x, playAgainBtn.y = halfW, 600
	
	currentLevel = "main"	
	checkForFile(currentLevel)
	

	printHighScore(currentLevel)
	highScoreText.x, highScoreText.y = halfW + 20, 428
	highScoreText.size = 40
	highScoreText:setTextColor(0, 0, 0)
	
	printLastScore(currentLevel)
	lastScoreText.x, lastScoreText.y = halfW + 20, 350
	lastScoreText.size = 40
	lastScoreText:setTextColor(0, 0, 0)
	
	winMusic = audio.play(winSound)
	
	group:insert( playAgainBtn )
	group:insert( highScoreText )
	group:insert( lastScoreText )
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	display.remove( background )
	display.remove( scoreboard )
	display.remove( playAgainBtn )
	display.remove( highScoreText )
	display.remove( lastScoreText )
	audio.stop(winMusic)
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