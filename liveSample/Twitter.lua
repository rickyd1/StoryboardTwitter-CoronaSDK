-- Project: Twitter sample app
--
-- File name: Twitter.lua
--
-- Author: Corona Labs
--
-- Abstract: Demonstrates how to connect to Twitter using Oauth Authenication.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local oAuth = require "oAuth"

-- Fill in the following fields from your Twitter app account
consumer_key = 'ik4P5KP8UGpr5iUTT14WHw'			-- key string goes here
consumer_secret = 'Z5yAKAE2B4Rho3VjI491jnNBA3Zoul2BGs45K2Otz0'		-- secret string goes here

-- The web URL address below can be anything
-- Twitter sends the webaddress with the token back to your app and the code strips out the token to use to authorise it
--
webURL = "http://www.keikiapps.com"

-- Note: Once logged on, the access_token and access_token_secret should be saved so they can
--	     be used for the next session without the user having to log in again.
-- The following is returned after a successful authenications and log-in by the user
--
local access_token
local access_token_secret
local user_id
local screen_name

-- Local variables used in the tweet
local postMessage
local delegate

-- Display a message if there is not app keys set
--
if not consumer_key or not consumer_secret then
	-- Handle the response from showAlert dialog boxbox
	--
	local function onComplete( event )
		if event.index == 1 then
			system.openURL( "https://dev.twitter.com//" )
		end
	end

	native.showAlert( "Error", "To develop for Twitter, you need to get an API key and application secret. This is available from Twitter's website.",
		{ "Learn More", "Cancel" }, onComplete )
end

-----------------------------------------------------------------------------------------
-- Twitter Authorization Listener
-----------------------------------------------------------------------------------------
--
local function listener(event)
	print("listener: ", event.url)
	local remain_open = true
	local url = event.url

	if url:find("oauth_token") and url:find(webURL) then
		url = url:sub(url:find("?") + 1, url:len())

		local authorize_response = responseToTable(url, {"=", "&"})
		remain_open = false

		local access_response = responseToTable(oAuth.getAccessToken(authorize_response.oauth_token,
			authorize_response.oauth_verifier, twitter_request_token_secret,
			consumer_key, consumer_secret, "https://api.twitter.com/oauth/access_token"), {"=", "&"})
		
		access_token = access_response.oauth_token
		access_token_secret = access_response.oauth_token_secret
		user_id = access_response.user_id
		screen_name = access_response.screen_name
		
		print( "Tweeting" )
		
			-- API CALL:
		------------------------------
		--change the message posted
		local params = {}
		params[1] =
		{
			key = 'status',
			value = postMessage
		}
		
		request_response = oAuth.makeRequest("http://api.twitter.com/1/statuses/update.json",
			params, consumer_key, access_token, consumer_secret, access_token_secret, "POST")
			
		--`print("req resp ",request_response)
		
		delegate.twitterSuccess()

	elseif url:find(webURL) then
		-- Logon was canceled
		remain_open = false
		delegate.twitterCancel()
		
	end

	return remain_open
end

-----------------------------------------------------------------------------------------
-- RESPONSE TO TABLE
--
-- Strips the token from the web address returned
-----------------------------------------------------------------------------------------
--
function responseToTable(str, delimeters)
	local obj = {}

	while str:find(delimeters[1]) ~= nil do
		if #delimeters > 1 then
			local key_index = 1
			local val_index = str:find(delimeters[1])
			local key = str:sub(key_index, val_index - 1)
	
			str = str:sub((val_index + delimeters[1]:len()))
	
			local end_index
			local value
	
			if str:find(delimeters[2]) == nil then
				end_index = str:len()
				value = str
			else
				end_index = str:find(delimeters[2])
				value = str:sub(1, (end_index - 1))
				str = str:sub((end_index + delimeters[2]:len()), str:len())
			end
			obj[key] = value
			--print(key .. ":" .. value)		-- **debug
		else
	
			local val_index = str:find(delimeters[1])
			str = str:sub((val_index + delimeters[1]:len()))
	
			local end_index
			local value
	
			if str:find(delimeters[1]) == nil then
				end_index = str:len()
				value = str
			else
				end_index = str:find(delimeters[1])
				value = str:sub(1, (end_index - 1))
				str = str:sub(end_index, str:len())
			end
			
			obj[#obj + 1] = value
			--print(value)					-- **debug
		end
	end
	
	return obj
end

-----------------------------------------------------------------------------------------
-- Tweet
--
-- Sends the tweet. Authorizes if no access token
-----------------------------------------------------------------------------------------
--
function tweet(del, msg)
	postMessage = msg
	delegate = del
	
	-- Check to see if we are authorized to tweet
	if not access_token then
		print( "Authorizing account" )
		
		if not consumer_key or not consumer_secret then
			-- Exit if no API keys set (avoids crashing app)
			delegate.twitterFailed()
			return
		end
		
		-- Need to authorize first
		--
		-- Get temporary token
		local twitter_request = (oAuth.getRequestToken(consumer_key, webURL,
			"http://twitter.com/oauth/request_token", consumer_secret))
		local twitter_request_token = twitter_request.token
		local twitter_request_token_secret = twitter_request.token_secret

		if not twitter_request_token then
			-- No valid token received. Abort
			delegate.twitterFailed()
			return
		end
		
		-- Request the authorization
		native.showWebPopup(0, 0, display.contentWidth, display.contentHeight, "http://api.twitter.com/oauth/authorize?oauth_token="
			.. twitter_request_token, {urlRequest = listener})
	else
		print( "Tweeting" )
		
		------------------------------
		-- API CALL:
		------------------------------
		--change the message posted
		local params = {}
		params[1] =
		{
			key = 'status',
			value = postMessage
		}
		
--t-	request_response = oAuth.makeRequest("http://requestb.in/rllkvvrl", 

		request_response = oAuth.makeRequest("http://api.twitter.com/1/statuses/update.json",
			params, consumer_key, access_token, consumer_secret, access_token_secret, "POST")
			
		--print("Tweet response: ",request_response)
		
		delegate.twitterSuccess()
	end
end