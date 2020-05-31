------------------------------------------------------------------------------------------------------------------------------------
-- Fall Fu Panda
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Apps.com [http:www.deepbueapps.com]
------------------------------------------------------------------------------------------------------------------------------------
-- Abstract: Originally developed by Darren Spencer of Utopian Games & Deep Blue Apps
-- as a GameSalad Project. Converted to Corona (Lua) by Wayne Hawksworth of Deep Blue Apps and Deep Blue Ideas
-- Rotate the World around the Panda to land on the enemies.
-- Technique shown in this project focuses heavily on the use of Physics and Joints to simulate the the game world.
-- As the player touches the LEFT or RIGHT side of the screen the world is re-pinned with a Weld joint to the current
-- world data. This newly pinned Physics object is then rotated about it's centre - causing the illusion of offset
-- rotation with the other world objects.
------------------------------------------------------------------------------------------------------------------------------------
--
-- main.lua
--
------------------------------------------------------------------------------------------------------------------------------------
-- 12th July 2016
-- Version 5.0
-- Requires Corona 2906
------------------------------------------------------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

-- require controller module
local composer 			= require( "composer" )
local physics 			= require( "physics" )

_G.sprite = require "sprite"							-- Add SPRITE API for Graphics 1.0

_G._w 					= display.contentWidth  		-- Get the devices Width
_G._h 					= display.contentHeight 		-- Get the devices Height
_G.gameScore			= 0								-- The Users score
_G.highScore			= 0								-- Saved HighScore value
_G.numberOfLevels		= 3								-- How many levels does the game have?
_G.currentLevel			= 1								-- What level to start on?
_G.levelsUnlocked		= 1								-- How many levels has the user unlocked?
_G.volumeMusic			= 0.3							-- Default SFX Volume
_G.volumeSFX			= 0.2							-- Default Music Volume
_G.numberOfEnemies		= 0

-- Enable debug by setting to [true] to see FPS and Memory usage.
local doDebug 			= false


-- Debug Data
if (doDebug) then
	local fps = require("fps")
	local performance = fps.PerformanceOutput.new();
	performance.group.x, performance.group.y = display.contentWidth/2,  270;
	performance.alpha = 0.3; -- So it doesn't get in the way of the rest of the scene
end



function startGame()
	-- load first screen
	image:removeSelf()
	image=nil
	composer.gotoScene( "startScreen" )	--This is our main menu
end

image = display.newImageRect( "Default.png",480,320 )
image.x = display.contentWidth/2
image.y = display.contentHeight/2

--Start GAme after a short delay.
timer.performWithDelay(2200, startGame )


--Define some globally loaded assets
hitEnemySound 		= audio.loadSound( "assets/extra_life.mp3" )
bgMusic			    = audio.loadSound( "assets/Fisshu_Ninja.mp3" )
gameOverSound		= audio.loadSound( "assets/game_over.mp3" )


audio.setVolume( volumeMusic, { channel=1 } ) 	-- set the volume on channel 2
audio.setVolume( volumeSFX, { channel=2 } ) 	-- set the volume on channel 1
