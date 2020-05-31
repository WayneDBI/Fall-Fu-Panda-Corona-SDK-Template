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
-- mainGameInterface.lua
--
------------------------------------------------------------------------------------------------------------------------------------
-- 12th July 2016
-- Version 5.0
-- Requires Corona 2906
------------------------------------------------------------------------------------------------------------------------------------

-- Build more scenes using the GUMBO tool, then use the co-ordinates of the obsticles
-- and Enemies to update the code below for a Scene 2, 3 4 etc...

-- Collect relevant external libraries
local composer 				= require( "composer" )
local scene 				= composer.newScene()

--local externalObjects = require "extCreateWorldObjects"

--collectScene = require("level1")

-- vars local
bgObjects_Group 		= nil
circle_Group 			= nil
player_Group			= nil
world_Group				= nil
bgRotating 				= false
pandIsFalling			= true
currentAngle			= 0
local panda				    = nil
pandaMotion				= nil
levelWinSprite			= nil
zoomSprite				= nil
worldCircle 			= nil
maxBounds			    = 180
--numberOfEnemies			= 0	--NOW A GLOBAL FROM MAIN !
enemiesCollected		= 0
enemy				    = {}
crates				  	= nil
worldWall			  	= nil
scoreText			  	= nil
spawnX				  	= 0
spawnY				  	= 0
gameOverBool			= false
levelCompleted			= false
isZooming			  	= false
holdOldX			  	= 0
holdOldY			  	= 0
debugON           		= false
pandaOnPlatform 		= false
rotationSpeed			= 200  --Lower number = Faster Rotation
zoomOutSpeed			= 400
zoomInSpeed				= 800
--level					= 1		--Default starting Level

_W 		= display.contentWidth/2
_H 		= display.contentHeight/2
_MH  	= display.contentHeight


-- Initiate the Main Game Group
local game = display.newGroup();
game.x = 0

-----------------------------------------------------------------
-- Setup the Physics World
-----------------------------------------------------------------
physics.start()
physics.setScale( 120 )
physics.setGravity( 0, 15 )
physics.setPositionIterations(128)

-- un-comment to see the Physics world over the top of the Sprites
--physics.setDrawMode( "hybrid" )


-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
	
		-----------------------------------------------------------------
		-- Setup the Panda SpriteSheet data
		-----------------------------------------------------------------
		local spriteSheetGroup = sprite.newSpriteSheetFromData( "assets/pandaSheet.png", require("pandaSheet").getSpriteSheetData() )
		
		local spritePandaSet = sprite.newSpriteSet(spriteSheetGroup,1,6)
		sprite.add(spritePandaSet,"pandaIdle",2,3,400,-2)
		sprite.add(spritePandaSet,"pandaFall",5,1,400,0)
		sprite.add(spritePandaSet,"pandaLand",6,1,1400,0)
		sprite.add(spritePandaSet,"pandaDie",1,1,1400,0)
		panda = sprite.newSprite( spritePandaSet )
		
		local spriteSetBlur = sprite.newSpriteSet(spriteSheetGroup,1,1)
		sprite.add(spriteSetBlur,"pandaBlur",7,4,300,-2)
		pandaMotion = sprite.newSprite( spriteSetBlur )

		local spriteSetWin = sprite.newSpriteSet(spriteSheetGroup,1,1)
		sprite.add(spriteSetWin,"levelWinSprite",12,1,300,0)
		levelWinSprite = sprite.newSprite( spriteSetWin )

		local spriteSetZoom = sprite.newSpriteSet(spriteSheetGroup,1,1)
		sprite.add(spriteSetZoom,"zoomSprite",11,1,300,0)
		zoomSprite = sprite.newSprite( spriteSetZoom )

		 spriteSetEnemy = sprite.newSpriteSet(spriteSheetGroup,1,1)
		sprite.add(spriteSetEnemy,"enemySprite",19,1,300,-2)

		
		
		
		-----------------------------------------------------------------
		-- Setup our World/Scene with Platforms and Enemies
		-----------------------------------------------------------------
		bgObjects_Group = display.newGroup()
		
		
		---------------------------------------------------------------------------
		-- Setup a Bounding Physics object to GLUE our Background Objects together
		---------------------------------------------------------------------------
		circle_Group = display.newGroup()
		circle = display.newCircle( _W,_H, 2000 ) 
		circle:setFillColor( 0, 0, 0 )  
		circle.alpha = 0
		circle.isSensor = true
		circleCollisionFilter = { categoryBits = 1, maskBits = 1 } 
		physics.addBody( circle, "kinematic", { density=3.0, friction=0.5, bounce=0.3, radius=circle.width/2, filter=circleCollisionFilter } )
		circle_Group:insert(circle)
				
		-----------------------------------------------------------------
		-- Load the Level and return how many ENEMIES there are to collect.
		-----------------------------------------------------------------
		numberOfEnemies = 0
		print(numberOfEnemies)
		
		collectScene = require("level"..currentLevel) --We dynamically load the correct level.
		numberOfEnemies = collectScene.createSceneObjects()		

		print(numberOfEnemies)

		-----------------------------------------------------------------
		-- Setup the Background Sky sprite
		-----------------------------------------------------------------
		bgSky = display.newImageRect( "assets/background"..currentLevel..".png",1024,1024 )
		bgSky.x = game.x
		bgSky.y = game.y
		game:insert( bgSky )
		-----------------------------------------------------------------
		-- Insert the LEVEL Scene Data into the contolled Game Group
		-----------------------------------------------------------------
		game:insert( bgObjects_Group )
		

	
		-----------------------------------------------------------------
		-- Set the Rotation buttons in our world (Left Half of Screen & Right.)
		-----------------------------------------------------------------
		--rotatSceneLeft = display.newImageRect( "assets/touchPanel.png",240,320 )
		rotatSceneLeft = display.newRect(0,0,240,320)
		rotatSceneLeft.alpha = 0.01
		rotatSceneLeft.anchorX = 0.0		-- Graphics 2.0 Anchoring method
		rotatSceneLeft.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		rotatSceneLeft.x = 0
		rotatSceneLeft.y = _h/2
		rotatSceneLeft.id = 1
		--rotatSceneLeft:setReferencePoint( display.TopLeftReferencePoint )
		
		--rotatSceneRight = display.newImageRect( "assets/touchPanel.png",240,320 )
		rotatSceneRight = display.newRect(0,0,240,320)
		rotatSceneRight.alpha = 0.01
		rotatSceneRight.anchorX = 1.0		-- Graphics 2.0 Anchoring method
		rotatSceneRight.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		rotatSceneRight.x = _w
		rotatSceneRight.y = _h/2
		rotatSceneRight.id = 2
		--rotatSceneRight:setReferencePoint( display.TopLeftReferencePoint )

		-----------------------------------------------------------------
		-- Setup the Zoom Button from the SpriteSheet
		-----------------------------------------------------------------
		zoomSprite:prepare("zoomSprite")
		zoomSprite:play()
		zoomSprite.anchorX = 0.5		-- Graphics 2.0 Anchoring method
		zoomSprite.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		zoomSprite.x = 20
		zoomSprite.y = 300
		zoomSprite.id = 2
		--zoomSprite:setReferencePoint( display.TopLeftReferencePoint )
		
		-----------------------------------------------------------------
		-- Setup the Level Complete Sprite from the SpriteSheet
		-----------------------------------------------------------------
		levelWinSprite:prepare("levelWinSprite")
		levelWinSprite:play()
		levelWinSprite.x = _W
		levelWinSprite.y = _H
		levelWinSprite.alpha = 0.0
		levelWinSprite.id = 3
		--levelWinSprite:setReferencePoint( display.CenterReferencePoint )

				
		-----------------------------------------------------------------
		-- Setup abd Display the Score Text
		-----------------------------------------------------------------
		scoreText = display.newText( "Collected: 0 out of "..numberOfEnemies, 0, 0, native.systemFont, 16 )
		scoreText:setTextColor( 255 )
		--scoreText:setReferencePoint( display.CenterReferencePoint )
		scoreText.anchorX = 0.5		-- Graphics 2.0 Anchoring method
		scoreText.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		scoreText.x, scoreText.y = display.contentWidth * 0.5, 10
		
		
		-----------------------------------------------------------------
		-- Setup our Player Group of Objects
		-----------------------------------------------------------------
		player_Group = display.newGroup()
		local pandaCollisionFilter = { categoryBits = 1, maskBits = 6 } 
		
		local pandaArea = Nil
				
		panda.x = 508
		panda.y = -34
		panda:prepare("pandaIdle")
		panda:play()
		
		panda:scale(0.5,0.5)
		panda.myName = "panda"
		pandaArea = { -20,-30, 20,-30, 20,30, -20,30 }
		physics.addBody( panda, "dynamic", { density=3.0, friction=0.5, bounce=0.3, filter=pandaCollisionFilter, shape=pandaArea } )
		panda.isSleepingAllowed = true
		--panda.isBullet = false
		panda.isFixedRotation = true
		panda.linearDamping = 1
		player_Group:insert( panda )
		
		--Blur motion effect (hidden until required)
		pandaMotion.x = panda.x
		pandaMotion.y = panda.y-45
		pandaMotion.alpha = 0.9
		pandaMotion:prepare("pandaBlur")
		pandaMotion:play()
		
		pandaMotion:scale(0.5,0.5)
		pandaMotion.myName = "pandaBlur"
		player_Group:insert( pandaMotion )

		
		game:insert( player_Group )
		
		screenGroup:insert( game )
		screenGroup:insert( rotatSceneLeft )
		screenGroup:insert( rotatSceneRight )
		screenGroup:insert( zoomSprite )
		screenGroup:insert( scoreText )
		screenGroup:insert( levelWinSprite )

		-----------------------------------------------------------------
		-- Start the BG Music - Looping
		-----------------------------------------------------------------
		--audio.play(bgMusic, {loops = -1})


end
		
		
-- Called immediately after scene has moved onscreen:
function scene:show( event )
--	print( "Scene1: enterScene event" )
	
	-- remove previous scene's view
	composer.removeScene( "startScreen" )
	
	---------------------------------------------------------------------------------------------
	-- Add Listeners to out SCENE ROTATE BUTTONS and Scene Detection Actors (Panda and Enemies).
	---------------------------------------------------------------------------------------------
	rotatSceneLeft:addEventListener( "touch", touch)
	rotatSceneRight:addEventListener( "touch", touch)
	zoomSprite:addEventListener( "touch", zoomControl)

end
		

local function resetPandaToIdleStance()
	local vx, vy = panda:getLinearVelocity()
	
		if (bgRotating == false and vy < 1) then
			pandaOnPlatform = true
			panda:prepare("pandaIdle")
			panda:play()
		else
			pandaOnPlatform = false
		end
end



local spawnTable = {}


local function removeStarDelay()
	table.remove(spawnTable,1)
end


--Function to spawn an object
local function spawn(params)
    local object = display.newImage(params.image)
    object.x = _W 
    object.y = _H 
    
    transition.to( object, { y = 10, alpha = 0.0, rotation = 180, time=500, onComplete=removeStarDelay() } )


    --Set the objects table to a table passed in by parameters
    object.objTable = params.objTable
    --Automatically set the table index to be inserted into the next available table index
    object.index = #object.objTable + 1
    
    --Give the object a custom name
    object.myName = "Object : " .. object.index
    
    --The objects group
    --object.group = params.group or nil
    
    --If the function call has a parameter named group then insert it into the specified group
    --object.group:insert(object)
    
    --Insert the object into the table at the specified index
    object.objTable[object.index] = object
    
    return object
end



--Level completed code/functions
local function levelCompletedFunctionEnd()
	gameOverBool = true
	levelCompleted = true
	audio.stop()
	--audio.stop(gameOverSound)
	Runtime:removeEventListener( "enterFrame", pandaPos )
	Runtime:removeEventListener( "enterFrame", moveCamera )
	Runtime:removeEventListener ( "collision", onGlobalCollision )
	
	-- HERE YOU WOULD TAKE THE USER TO THE NEXT LEVEL !
	-- What we'll do is take the user to a CLEANOUT LUA PAGE
	-- Then Load the mainGameInterface again, but with LEVEL 2 data !
	composer.gotoScene( "failed", "crossFade", 1400  )
end 

local function endMusicCompleted()
	audio.play(gameOverSound, {onComplete=levelCompletedFunctionEnd})
	--timer.performWithDelay(2300, levelCompletedFunctionEnd )
end

local function doGameCompleted()
	gameOverBool = true
	levelCompleted = true
	transition.to( levelWinSprite, { alpha = 1.0, rotation = 360, time=600, onComplete=endMusicCompleted } )
end 



local function addToScore()

print("1:  "..numberOfEnemies)
	
	audio.play(hitEnemySound, {channel=2})
	
	enemiesCollected		= enemiesCollected + 1
	
	scoreText.text = "Collected: "..enemiesCollected.." out of "..numberOfEnemies
	--scoreText:setReferencePoint( display.CenterReferencePoint )
	scoreText.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	scoreText.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	scoreText.x, scoreText.y = display.contentWidth * 0.5, 10

	--Spawn a Flashy Star!
	local spawns = spawn(
			{
				image = "assets/obj_ko_star02.png",
				objTable = spawnTable,
			}
		)
	
	--Check to see if we have won by collecting all the enemies
	if (enemiesCollected == numberOfEnemies) then
		levelCompleted = true
		doGameCompleted()
	end
print("2:  "..numberOfEnemies)

end


local function removeAfterDelay(object)
--	print ("Destroying enemy!")
--	print ("x: ".. object.x)
--	print ("y: " ..object.y)
	
	spawnX = object.x
	spawny = object.y
			
	if (object.alpha > 0) then
		object.alpha = 0.0
		addToScore()
	end

end


local function gameOverFunctionEnd()
	gameOverBool = true
	audio.stop()
	--audio.stop(gameOverSound)
	Runtime:removeEventListener( "enterFrame", pandaPos )
	Runtime:removeEventListener( "enterFrame", moveCamera )

	display.remove( panda )
	panda = nil
	composer.gotoScene( "failed", "crossFade", 1400  )
end 

local function endMusic()
	audio.play(gameOverSound)
	timer.performWithDelay(2300, gameOverFunctionEnd )
end

local function gameOverFunctionStart()
	gameOverBool = true
	transition.to( panda, { xScale = 2.0, yScale = 2.0, rotation = 360, time=600, onComplete=endMusic } )
end 


local function onGlobalCollision( event )
	if ( event.phase == "began" and gameOverBool==false) then
	
		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision began" )
		
		if (event.object1.myName == "enemy" and event.object2.myName == "panda") then
			print ("Panda hit enemy!")
			timer.performWithDelay(100, removeAfterDelay(event.object1) )
         	
		elseif (event.object1.myName == "wall" and event.object2.myName == "panda") then --Panda must die!
			
			audio.stop()

			physics.setGravity(0,0)
			panda:setLinearVelocity( 0, 0 )
			
			panda:prepare("pandaDie")
			panda:play()
			pandaMotion.alpha = 0.0
			
			print ("Panda hit wall!")
			
			timer.performWithDelay(20, gameOverFunctionStart )
			
		else --Panda has landed safely
			panda:prepare("pandaLand")
			panda:play()
			pandaMotion.alpha = 0.0
			timer.performWithDelay(400, resetPandaToIdleStance )
		end

	elseif ( event.phase == "ended" ) then
	
		--timer.performWithDelay(200, resetPandaToIdleStance )
		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision ended" )

	end
	
	
end

---------------------------------------------------------------------------------
-- Reset Panda Location after death [Not used in this Template]
---------------------------------------------------------------------------------
local function resetPos()
	panda.x = 508
	panda.y = -34
	
	game.x = 0
	game.y = 0
	
	bgObjects_Group.x =game.x
	bgObjects_Group.y =game.y
	
	circle.Rotation = 0
end

----------------------------------------------------------------------------------------------
-- Lock the GAME.Group to the Pandas Central position - thus controlling the Camera..
----------------------------------------------------------------------------------------------
local function moveCamera()

	if (gameOverBool == false) then

		local vx, vy = panda:getLinearVelocity()
		
		if (bgRotating == true or vy > 1) then
			panda:prepare("pandaFall")
			panda:play()
			pandaMotion.x = panda.x
			pandaMotion.y = panda.y-45
			pandaMotion.alpha = 0.8
			transition.to( pandaMotion, {  alpha = 0, time=900, y=panda.y*0.4 } )
		end
		
		game.x = -(panda.x-240)
		game.y = -(panda.y-160)
		
		bgSky.x = _W-game.x-190
		bgSky.y = _H-game.y
				
	end
end


---------------------------------------------------------------------------------
-- Update and Remove our Controller Circle - the one we used for offset rotation
---------------------------------------------------------------------------------
local function updateGravity(event)
	if ( worldCircle ) then
		worldCircle:removeSelf()
		worldCircle = nil
		circle.bodyType = "kinematic"
	end
end




local finishedRotating = function( obj )
	bgRotating = false
	timer.performWithDelay(50, updateGravity )
end


function finishedZooming()
  isZooming = false
end


function zoomBack()
	transition.to( game,  { x=game.x*2.0, y=game.y*2.0, time=zoomInSpeed} )
	transition.to( game,  { xScale = 1.0, yScale = 1.0, time=zoomInSpeed, onComplete=finishedZooming } )
	transition.to( bgSky, { xScale = 1.0, yScale = 1.0, time=zoomInSpeed } )
end		


function zoomControl( event )
	holdOldX = game.x
	holdOldY = game.y

	if (event.phase == 'began' and bgRotating == false and isZooming == false) then
		isZooming = true
		holdOldX = game.x
		holdOldY = game.y
	
	--print ("--------------------------------")
	--print ("PandaX: "..panda.x)
	--print ("PandaY: "..panda.y)
	--print ("HoldOld Game X: "..holdOldX)
	--print ("HoldOld Game Y: "..holdOldY)
	--print ("Game X: "..game.x)
	--print ("Game Y: "..game.y)

		transition.to( game,  { x=game.x*0.5, y=game.y*0.5, time=zoomOutSpeed} )
		transition.to( game,  { xScale = 0.5, yScale = 0.5, time=zoomOutSpeed, onComplete=zoomBack } )
		transition.to( bgSky, { xScale = 3.0, yScale = 3.0, time=zoomOutSpeed } )
	end
	
end


function touch( event )

	if (event.phase == 'began') then
	
		if (bgRotating == false and isZooming == false and pandaOnPlatform == true) then
		
			--print("Panda X: "..panda.x)
			--print("Panda Y: "..panda.y)

				if ( worldCircle == nil ) then

					bgRotating = true
					
					--Change game controlled circle to Dynamic
					circle.bodyType = "dynamic"
				
					-- Before rotation begins - Pin a NEW circle to the Pandas central points
					-- We'll rotate this Welded Circle so the offset Rotation relative to Panda is applied
					worldCircle = display.newCircle(panda.x,panda.y,10)
					worldCircle.myName = "worldCircle"
					worldCircle:setFillColor( 0, 0, 0 )
					worldCircle.alpha = 0.0
					worldCircle.isSensor = true
					
					local circleCollisionFilter = { categoryBits = 1, maskBits = 1 }
					physics.addBody( worldCircle, "kinematic", { density=3.0, friction=0.5, bounce=0.3, radius=worldCircle.width/2, filter=circleCollisionFilter } )
					myJoint = physics.newJoint( "weld", worldCircle, circle, 0,0)

					local btnId = event.target.id
					local targetAngle = Nil
									
					if (btnId == 1) then
						--print ( "Going Left")
						currentAngle = 0 - 90
					else
						--print ( "Going Right")
						currentAngle = 0 + 90
					end 
					
					targetAngle = currentAngle
			
					transition.to( worldCircle, { rotation = targetAngle, 	time=rotationSpeed, onComplete=finishedRotating } )
					transition.to( bgSky,       { rotation = 0, 			time=rotationSpeed, onComplete=finishedRotating } )
				end
			
			
		end
	
	end
	
	return true
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
--	print( "Scene1: exitScene event" )
	
	rotatSceneLeft:removeEventListener( "touch", touch)
	rotatSceneRight:removeEventListener( "touch", touch)
	zoomSprite:removeEventListener( "touch", zoomControl)
	Runtime:removeEventListener ( "collision", onGlobalCollision )
	Runtime:removeEventListener( "enterFrame", moveCamera )
	
	audio.stop()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
--	print( "((destroying scene 1's view))" )
end



-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------



Runtime:addEventListener ( "collision", onGlobalCollision )
Runtime:addEventListener( "enterFrame", moveCamera )

return scene