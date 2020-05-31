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
-- startScreen.lua
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

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image

-- level select button function
local function levelSelect()
		composer.gotoScene( "mainGameInterface", "fade", 400  )
		return true
end

-- options select button function
local function optionsSelect()
		composer.gotoScene( "optionsScreen", "fade", 400  )
		return true
end

-- info select button function
local function infoSelect()
		composer.gotoScene( "infoScreen", "fade", 400  )
		return true
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
		
	----------------------------------------------------------------------------------------------------
	-- Setup the Background Image
	----------------------------------------------------------------------------------------------------
	image = display.newImageRect( "assets/background2.png",480,320 )
	image.x = _w/2
	image.y = _h/2
	--transition.to(image, {alpha=1.0, time=500})
	screenGroup:insert( image )
	
	----------------------------------------------------------------------------------------------------
	-- Setup the Highlight bar
	----------------------------------------------------------------------------------------------------
	highlight = display.newImageRect( "assets/highlight.png",480,64 )
	highlight.x = _w+200
	highlight.y = _h/2
	highlight.alpha = 1.0
	highlight.rotation = -55
	highlightGroup:insert( highlight )
	screenGroup:insert( highlightGroup )
	
	----------------------------------------------------------------------------------------------------
	-- Setup the start game button
	----------------------------------------------------------------------------------------------------
	local infoButton = widget.newButton{
		left 	= _w-186,
		top 	= _h-170,
		defaultFile = "assets/buttonStartOff.png",
		overFile 	= "assets/buttonStartOn.png",
		onRelease = levelSelect,
		}			
	buttonGroup:insert( infoButton )
	--Insert the Info Group Layer into the Main Layer
	screenGroup:insert( buttonGroup )

	----------------------------------------------------------------------------------------------------
	-- Setup the options button
	----------------------------------------------------------------------------------------------------
	local optionsButton = widget.newButton{
		left 	= _w-186,
		top 	= _h-120,
		defaultFile = "assets/buttonOptionsOff.png",
		overFile 	= "assets/buttonOptionsOn.png",
		onRelease = optionsSelect,
		}			
	buttonGroup:insert( optionsButton )
	--Insert the Info Group Layer into the Main Layer
	screenGroup:insert( buttonGroup )
	
	----------------------------------------------------------------------------------------------------
	-- Setup the info button
	----------------------------------------------------------------------------------------------------
	local infoButton = widget.newButton{
		left 	= _w-186,
		top 	= _h-70,
		defaultFile = "assets/buttonInfoOff.png",
		overFile 	= "assets/buttonInfoOn.png",
		onRelease = infoSelect,
		}			
	buttonGroup:insert( infoButton )
	--Insert the Info Group Layer into the Main Layer
	screenGroup:insert( buttonGroup )
	
	
	----------------------------------------------------------------------------------------------------
	-- Setup the Logo - with Bounce in effect
	----------------------------------------------------------------------------------------------------
	imageLogo = display.newImageRect( "assets/mainLogo.png",460,244 )
	imageLogo.x = (_w/2)+15
	imageLogo.y = -100
	
	templateInfo = display.newImageRect( "assets/infoText.png",426,72 )
	templateInfo.x = (_w/2)
	templateInfo.y = 285
	templateInfo:scale(1.0,0.1)
	templateInfo.alpha = 0.0
	screenGroup:insert( templateInfo )

	function bounceUp()
		transition.to(logoGroup, {y=230, time=150}) 								--Bounce the logo back up a little
		transition.to(templateInfo, {alpha=1.0, yScale=1.0, time=500})				--Flip in the Template info details
		transition.to(highlight, {alpha=0.0,xScale=7.0, yScale=7.0, x=0, time=800})	--Swipe the Highlight across the screen	
	end
	logoGroup:insert( imageLogo )
	transition.to(logoGroup, {y=270, time=350, onComplete=bounceUp})
	screenGroup:insert( logoGroup )

	-----------------------------------------------------------------
	-- Start the BG Music - Looping
	-----------------------------------------------------------------
	audio.play(bgMusic, {channel=1, loops = -1})

end





-- Called immediately after scene has moved onscreen:
function scene:show( event )
	-- remove previous scene's view
	composer.removeScene( "failed" )
	composer.removeScene( "mainGameInterface" )
	composer.removeScene( "infoScreen" )
	composer.removeScene( "optionsScreen" )
	composer.removeScene( "level1" )
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	-- remove touch listener for image
	--image:removeEventListener( "touch", image )
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

return scene