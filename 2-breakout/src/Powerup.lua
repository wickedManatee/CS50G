--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Will Mearns

    Tracks powerups spawned in the game
]]

Powerup = Class{}

function Powerup:init(x, power)
    self.x = x
    self.y = 0
    self.dy = power * 32
    self.width = 16
    self.height = 16
	self.power = power
end

function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.power], self.x, self.y)
end