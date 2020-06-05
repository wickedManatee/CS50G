--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
	self.carriedBy = nil
	self.thrownStartX = -1
	self.thrownStartY = -1
	self.dy = 0
	self.dx = 0
	
    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states
	self.brokenTimer = 3

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

	-- default empty collision callback
    self.onCollide = function() end 
end

function GameObject:update(dt)
	if self.carriedBy ~= nil then
		self.x = self.carriedBy.x
		self.y = self.carriedBy.y - (self.height / 2 )
		self.solid = false
	else
		if self.thrownStartX ~= -1 and self.state ~= 'broken' then
			print('throwing from x/y ' .. self.x .. '/' .. self.y)
			self.solid = true
			self.x = self.x + (self.dx * dt)
			self.y = self.y + (self.dy * dt)
			print('to x/y ' .. self.x .. '/' .. self.y)
			if self:outOfBounds() then
				self:breakPot()
			elseif math.abs(self.thrownStartX - self.x) >= (3 * TILE_SIZE) or math.abs(self.thrownStartY - self.y) >= (3 * TILE_SIZE) then
				self:breakPot()
			end
		end
	end
	if self.state == 'broken' and self.brokenTimer > 0 then
		self.brokenTimer = self.brokenTimer - dt
	end
end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:throw(direction)
	print('throw ' .. tostring(direction))
	if direction == 'left' then
		self.thrownStartX = self.carriedBy.x - self.width
		self.thrownStartY = self.carriedBy.y
		self.x = self.thrownStartX - 2
		self.y = self.thrownStartY
		self.dx = -50
		self.dy = 0
	elseif direction == 'right' then
		self.thrownStartX = self.carriedBy.x + self.carriedBy.width
		self.thrownStartY = self.carriedBy.y
		self.x = self.thrownStartX + 2
		self.y = self.thrownStartY
		self.dx = 50
		self.dy = 0
	elseif direction == 'up' then
		self.thrownStartX = self.carriedBy.x
		self.thrownStartY = self.carriedBy.y - self.height
		self.x = self.thrownStartX 
		self.y = self.thrownStartY - 2
		self.dx = 0
		self.dy = -50
	elseif direction == 'down' then
		self.thrownStartX = self.carriedBy.x
		self.thrownStartY = self.carriedBy.y + self.carriedBy.height
		self.x = self.thrownStartX 
		self.y = self.thrownStartY + 2
		self.dx = 0
		self.dy = 50
	end
	self.carriedBy = nil
end

function GameObject:outOfBounds()
	if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
            self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            return true
    elseif self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
            self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
            return true
    elseif self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then 
            self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
            return true
    else
		local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

        if self.y + self.height >= bottomEdge then
            self.y = bottomEdge - self.height
            return true
		end
	end
end

function GameObject:breakPot()
	gSounds['crash']:play()
	self.state = 'broken'
	self.dx = 0
	self.dy = 0	
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end