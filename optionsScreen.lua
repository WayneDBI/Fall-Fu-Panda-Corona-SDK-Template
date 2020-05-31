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
-- infoScreen.lua
--
------------------------------------------------------------------------------------------------------------------------------------
-- 12th July 2016
-- Version 5.0
-- Requires Corona 2906
------------------------------------------------------------------------------------------------------------------------------------

local composer 				= require( "composer" )
local scene 				= composer.newScene()
local ui 					= require("ui")
local widget 				= require "widget"
local buttonGroup 			= display.newGroup()
local logoGroup 			= display.newGroup()
local highlightGroup 		= display.newGroup()
local highlightSpeed		= 20

local sliderSFX
local sliderMUSIC

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- level select button function
local function backToMenu()
	composer.gotoScene( "startScreen", "fade", 400  )
	return true
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
		
	----------------------------------------------------------------------------------------------------
	-- Setup the Background Image
	----------------------------------------------------------------------------------------------------
	local image = display.newImageRect( "assets/optionsScreen.png",480,320 )
	image.x = _w/2
	image.y = _h/2
	screenGroup:insert( image )
	
	----------------------------------------------------------------------------------------------------
	-- Setup the start game button
	----------------------------------------------------------------------------------------------------
	local menuButton = widget.newButton{
		left 	= _w-170,
		top 	= _h-50,
		defaultFile = "assets/buttonMenuOff.png",
		overFile 	= "assets/buttonMenuOn.png",
		onRelease = backToMenu,
		}			
	screenGroup:insert( menuButton )

	----------------------------------------------------------------------------------------------------
	-- Setup the SFX Slider Controls
	----------------------------------------------------------------------------------------------------
	-- SFX Volume Slider update data
	local function playSampleSFX()
		audio.play(hitEnemySound, {channel=2})
	end
	
	local function sliderSXFEvent( event )
		volumeSFX = event.value/100
		audio.setVolume( volumeSFX, { channel=2 } ) 	-- set the volume on channel 1
		audio.stop(2)
		timer.performWithDelay(200, playSampleSFX )
	end

	--Create the SFX Slider
	sliderSFX = widget.newSlider{
		top = 215, left = 100, width = 360, value = volumeSFX, listener = sliderSXFEvent }
		
	screenGroup:insert( sliderSFX )
	sliderSFX:setValue(volumeSFX*100)
	
	----------------------------------------------------------------------------------------------------
	-- Setup the MUSIC Slider Controls
	----------------------------------------------------------------------------------------------------
	-- SFX Volume Slider update data
	local function sliderMusicEvent( event )
		volumeMusic = event.value/100
		audio.setVolume( volumeMusic, { channel=1 } ) 	-- set the volume on channel 2
		print(volumeMusic)
	end

	--Create the Music Slider
	sliderMUSIC = widget.newSlider{
		top = 245, left = 100, width = 360, value = volumeMusic, listener = sliderMusicEvent }
		
	screenGroup:insert( sliderMUSIC )
	sliderMUSIC:setValue(volumeMusic*100)
end



-- Called immediately after scene has moved onscreen:
function scene:show( event )
	
	-- remove previous scene's view
	composer.removeScene( "startScreen" )
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	
	print( "((destroying scene 1's view))" )
end

---------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene