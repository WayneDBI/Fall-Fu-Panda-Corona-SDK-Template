---------------------------------------------------------------------------
-- Add the Crates and Obsticles
---------------------------------------------------------------------------
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

local externalObjects = {addNewCrates=addNewCrates}

return externalObjects