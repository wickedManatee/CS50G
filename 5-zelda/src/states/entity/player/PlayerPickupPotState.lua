PlayerPickupPotState = Class{__includes = BaseState}

function PlayerPickupPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
	
    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    self.potHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('pickup-pot-' .. self.player.direction)
end

function PlayerPickupPotState:enter(params)
    gSounds['powerup-reveal']:stop()
    gSounds['powerup-reveal']:play()

    -- restart animation
    self.player.currentAnimation:refresh()
end

function PlayerPickupPotState:update(dt)
    -- check if hitbox collides with any entities in the scene
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.potHitbox) and object.type == 'pot' and object.state ~= 'broken' then
			self.player.hasPot = object
            gSounds['pickup']:play()
			object.carriedBy = self.player
        end
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerPickupPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
     --love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
     --love.graphics.rectangle('line', self.potHitbox.x, self.potHitbox.y,
     --    self.potHitbox.width, self.potHitbox.height)
     --love.graphics.setColor(255, 255, 255, 255)
end