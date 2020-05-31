------------------------------------------------------------------------------------------------------------------------------------
-- Kung Fu Panda
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
-- failed.lua
--
------------------------------------------------------------------------------------------------------------------------------------
-- 12th July 2016
-- Version 5.0
-- Requires Corona 2906
------------------------------------------------------------------------------------------------------------------------------------

local composer 				= require( "composer" )
local scene 				= composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image

-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		composer.gotoScene( "startScreen", "fade", 400  )
		return true
	end
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
	
	image = display.newImageRect( "assets/FallFu_gameover.png",480,320 )
	image.x = display.contentWidth/2
	image.y = display.contentHeight/2

	screenGroup:insert( image )
	image.touch = onSceneTouch
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )

	audio.stop()
	--audio.stop(gameOverSound)

	image:addEventListener( "touch", image )

	-- remove previous scene's view
	composer.removeScene( "mainGameInterface" )
	composer.removeScene( "level1" )
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
		
	-- remove touch listener for image
	image:removeEventListener( "touch", image )
	audio.stop()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	
	print( "((destroying scene 1's view))" )
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

return scene