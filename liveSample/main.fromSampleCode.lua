-- Project: Twitter sample app
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Demonstrates how to connect to Twitter using Oauth Authenication.
--
--
-- File dependencies: TwiterManager.lua, oAuth.lua
--
-- Target devices: simulator, device
--
-- Limitations: Requires internet access; no error checking if connection fails
--
-- Update History:
--	v1.2		Twitter app redesigned for Oauth
--
--
-- Comments:
-- Requires API key and application secret key from Twitter. To begin, log into your Twiter
-- account and add the "Developer" application, from which you can create additional apps.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

local TwitterManager = require( "Twitter" )
local widget = require( "widget" )

-- Layout Locations
local StatusMessageY = 420		-- position of status message

local background = display.newImage( "tweetscreen.jpg" )
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2

--------------------------------
-- Create Status Message area
--------------------------------
--
local function createStatusMessage( message, x, y )
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

local statusMessage = createStatusMessage( "   Not connected  ", 0.5*display.contentWidth, StatusMessageY )

local callback = {}

-- Callbacks
function callback.twitterCancel()
	print( "Twitter Cancel" )
	statusMessage.textObject.text = "Twitter Cancel"
end

function callback.twitterSuccess()
	print( "Twitter Success" )
	statusMessage.textObject.text = "Twitter Success"
end

function callback.twitterFailed()
	print( "Failed: Invalid Token" )
	statusMessage.textObject.text = "Failed: Invalid Token"
end

local time

--------------------------------
-- Tweet the message
--------------------------------
--
local function tweetit( event )
	time = os.date( "*t" )		-- Get time to append to our tweet
	local value = "Posted from Corona SDK at www.coronalabs.com at " ..time.hour .. ":"
			.. time.min .. "." .. time.sec
	TwitterManager.tweet(callback, value)
end

--------------------------------
-- Create "Tweet" Button
--------------------------------
--
-- Created without images
--
twitterButton = widget.newButton{
	id = "button1",
	default = "smallButton.png",
	over = "smallButtonOver.png",
	label = "Tweet",
	left = 380,
	top = 300,
	width = 140, height = 50,
	fontSize = 40,
	onRelease = tweetit
}
	
twitterButton.x = display.contentWidth / 2
twitterButton.y = display.contentHeight - display.contentHeight / 4
