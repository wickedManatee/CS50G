--[[
    GD50
    Super Mario Bros. Remake

    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

function GameLevel:init(entities, objects, tilemap)
    self.entities = entities
    self.objects = objects
    self.tileMap = tilemap
end

--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function GameLevel:clear()
    for i = #self.objects, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end

    for i = #self.entities, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end
end

function GameLevel:update(dt)
    self.tileMap:update(dt)

    for k, object in pairs(self.objects) do
        object:update(dt)
    end

    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function GameLevel:render()
    self.tileMap:render()

    for k, object in pairs(self.objects) do
        object:render()
    end

    for k, entity in pairs(self.entities) do
        entity:render()
    end
end

function GameLevel:removeLocks()
	for i = #self.objects, 1, -1 do
		if self.objects[i].texture == 'locks-keys' and self.objects[i].solid == true then
			table.remove(self.objects, i)
		end
	end
end

function GameLevel:spawnGoal(lvlWidth, lvlHeight)
	table.insert(self.objects, GameObject {
                        texture = 'flags-poles',
                        x = (lvlWidth - 2) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 48,
                        frame = POLES[math.random(#POLES)],
                        collidable = true,
						goal = true
                    }
				)
	table.insert(self.objects, GameObject {
                        texture = 'flags-poles',
                        x = ((lvlWidth - 2) * TILE_SIZE) + 8,
                        y = (5 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = FLAGS[math.random(#FLAGS)],
                        collidable = false
                    }
                )

end