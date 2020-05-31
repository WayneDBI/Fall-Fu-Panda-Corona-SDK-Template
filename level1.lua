module(..., package.seeall)

---------------------------------------------------------------------------
-- Add the Crates and Obsticles
---------------------------------------------------------------------------

function createSceneObjects()

	numberOfEnemies = 0
	
	local function addNewCrates(x ,y, sizeX, sizeY, angle, pngFile, newName)
	
		local crateCollisionFilter = { categoryBits = 2, maskBits = 3 } 
		local crateMaterial = { density=300.0, friction=0.5, bounce=0.3, filter=crateCollisionFilter }
	
		crates = display.newImageRect( pngFile, sizeX, sizeY )
		crates.alpha = 1.0
		crates.x = x
		crates.y = y
		crates.rotation = angle
		crates.myName = newName
		physics.addBody( crates, "dynamic", crateMaterial )
	
		bgObjects_Group:insert( crates )
		
		--Crates Welds to World Circle
		myJoint = physics.newJoint( "weld", circle, crates, x, y )
		
	end
	
		addNewCrates(41,222, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(169,94, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(507,94, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(506,313, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(414,-269, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(286,-269, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(748,-97, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(940,-225, 129, 129, 0, "assets/obj_box02.png", "crate")
		addNewCrates(588,-1, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(652,-1, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(844,44, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(346,227, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(510,-342, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(602,281, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(282,258, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(844,-308, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(844,-372, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(119,-67, 64, 64, 0, "assets/obj_box04.png", "crate")
		addNewCrates(55,-111, 64, 64, 0, "assets/obj_box01.png", "crate")
		addNewCrates(55,-175, 64, 64, 0, "assets/obj_box01.png", "crate")
		addNewCrates(55,-239, 64, 64, 0, "assets/obj_box01.png", "crate")
		addNewCrates(119,-287, 64, 64, 0, "assets/obj_box01.png", "crate")
		addNewCrates(731,144, 96, 32, 0, "assets/obj_box05.png", "crate")
		addNewCrates(312,-2, 96, 32, -90, "assets/obj_box05.png", "crate")		
		
		
		
		---------------------------------------------------------------------------
		-- Add the enemies to the scene
		---------------------------------------------------------------------------
		local function addNewEnemy(x ,y, sizeX, sizeY, angle, newName)
			local enemyCollisionFilter = { categoryBits = 2, maskBits = 3 } 
			local enemyArea = { -20,-20, 20,-20, 20,20, -20,20 }
			local enemyMaterial = { density=300.0, friction=0.5, bounce=0.3, filter=enemyCollisionFilter, shape=enemyArea }

			local enemyPrep = nil
			enemyPrep = sprite.newSprite( spriteSetEnemy )

			enemyPrep:prepare("enemySprite")
			enemyPrep:play()
			enemyPrep:scale(0.5,0.5)
			enemyPrep.alpha = 1.0
			enemyPrep.x = x
			enemyPrep.y = y
			enemyPrep.rotation = angle
			enemyPrep.myName = "enemy"
			enemyPrep.id = 1
			physics.addBody( enemyPrep, "dynamic", enemyMaterial )
			enemyPrep.isSensor = true
			myJoint = physics.newJoint( "weld", circle, enemyPrep, x, y )
			bgObjects_Group:insert( enemyPrep )
			
		  	-- Increase the Number of enemies.
		  	-- This value will be used later to auto detect of the user has 'collected' them all.
		  	numberOfEnemies = numberOfEnemies + 1
		end
		
		addNewEnemy(601,227, 44, 44, 0, "enemy1")
		addNewEnemy(203,8, 44, 44, 0,  "enemy2")
		addNewEnemy(127,188, 44, 44, 90,  "enemy3")
		addNewEnemy(109,-166, 44, 44, 90,  "enemy4")
		addNewEnemy(355,-183, 44, 44, 180, "enemy5")
		addNewEnemy(511,-288, 44, 44, 180,  "enemy6")
		addNewEnemy(790,-291, 44, 44, 270,  "enemy7")
		addNewEnemy(421,123, 44, 44, 270,  "enemy8")
		addNewEnemy(736,106, 44, 44, 0,  "enemy9")
		
		
		---------------------------------------------------------------------------
		-- Add the World Boundries (We'll use these to check for a Game Over)
		---------------------------------------------------------------------------
		function addWall( x, y, angle,  width, height )
		
			local wallCollisionFilter = { categoryBits = 2, maskBits = 3 } 
			local wallMaterial = { density=300.0, friction=0.5, bounce=0.3, filter=wallCollisionFilter }

			worldWall = display.newRect( 0, 0, width, height )
			worldWall.x = x
			worldWall.y = y
			worldWall.rotation = angle
			worldWall.myName = "wall"
			worldWall.alpha = 0.0
			physics.addBody( worldWall, "dynamic", wallMaterial )
			bgObjects_Group:insert( worldWall )
			myJoint = physics.newJoint( "weld", circle, worldWall, x, y )
		end
	
		addWall(490,-640,0,1350,16) 	--Top Wall
		addWall(490,532,0,1350,16)  	--Bottom
		addWall(-195,-50,-90,1200,16)	--Left
		addWall(1190,-50,-90,1200,16)	--Right
	

		-- Allow us to rotate the World circle with the other Physics body in toe!
		myJoint.isLimitEnabled = true

		-----------------------------------------------------------------
		-- Ensert the Scene Data Group into the world CIRCLE group
		-----------------------------------------------------------------
		bgObjects_Group:insert(circle_Group)
		
		-----------------------------------------------------------------
		-- Send back to the Main Game file how many enemies there are to collect.
		-----------------------------------------------------------------		
		return	numberOfEnemies
		
		
end