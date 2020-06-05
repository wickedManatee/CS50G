PlayerThrowPotState = Class{__includes = BaseState}

function PlayerThrowPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    
    self.player:changeAnimation('throw-pot-' .. self.player.direction)
end

function PlayerThrowPotState:enter(params)
    gSounds['powerup-reveal']:stop()
    gSounds['powerup-reveal']:play()

    self.player.currentAnimation:refresh()
	self.player.hasPot:throw(self.player.direction)
end

function PlayerThrowPotState:update(dt)
	if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
		self.player.hasPot = nil
        self.player:changeState('idle')
    end
end

function PlayerThrowPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end