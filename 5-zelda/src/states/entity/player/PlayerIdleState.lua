--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
	if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        if self.entity.hasPot then
			self.entity:changeState('walk-pot')
		else
			self.entity:changeState('walk')
		end
    end
	
	if love.keyboard.wasPressed('e') and not self.entity.hasPot then
        self.entity:changeState('pickup-pot')
    end
	
	if love.keyboard.wasPressed('e') and self.entity.hasPot then
        self.entity:changeState('throw-pot')
    end

    if love.keyboard.wasPressed('space') and not self.entity.hasPot then
        self.entity:changeState('swing-sword')
    end
end