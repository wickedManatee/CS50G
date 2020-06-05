--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]

local keySpawnTimer

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
	self.ballList = {self.ball}
	
	self.level = params.level
	self.levelWithLocks = params.levelWithLocks

    self.recoverPoints = params.recoverPoints
	self.paddleUpgradePoints = params.paddleUpgradePoints
	self.powerups = params.powerups  
	keySpawnTimer = math.random (KEY_SPAWN_TIME, KEY_SPAWN_TIME * 2)
	self.unlockedTime = 0
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end
	
	-- timer counts down the amount of time the player has left to hit the Locked brick
	if self.levelWithLocks then
		if keySpawnTimer > 0 then
			keySpawnTimer = keySpawnTimer - dt
		elseif keySpawnTimer <= 0 then
			local p = Powerup ( math.random(16, VIRTUAL_WIDTH-16), PU_KEY)
			table.insert(self.powerups, p)
			keySpawnTimer = math.random (KEY_SPAWN_TIME, KEY_SPAWN_TIME * 2)
		end
	end
	
	if self.unlockedTime > 0 then
		self.unlockedTime = self.unlockedTime - dt
	end
	
    -- update positions based on velocity
    self.paddle:update(dt)
    
	-- update balls
	for indx,ballInstance in pairs(self.ballList) do
		ballInstance:update(dt)
		
		if ballInstance:collides(self.paddle) then
			-- raise ball above paddle in case it goes below it, then reverse dy
			ballInstance.y = self.paddle.y - 8
			ballInstance.dy = -ballInstance.dy
			
			--
			-- tweak angle of bounce based on where it hits the paddle
			--

			-- if we hit the paddle on its left side while moving left...
			if ballInstance.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				ballInstance.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ballInstance.x))
			
			-- else if we hit the paddle on its right side while moving right...
			elseif ballInstance.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				ballInstance.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ballInstance.x))
			end

			gSounds['paddle-hit']:play()
			
			if ballInstance.collideCount > POWER_UP_HITS then
				local p = Powerup ( math.random(16, VIRTUAL_WIDTH-16), PU_MORE_BALLS)
				table.insert(self.powerups, p)
				ballInstance.collideCount = 0
			end
		end
			
		-- detect collision across all bricks with the ball
		for k, brick in pairs(self.bricks) do

			-- only check collision if we're in play
			if brick.inPlay and ballInstance:collides(brick) then
				if (not brick.isLocked) or
					(brick.isLocked and self.unlockedTime > 0) then
					-- add to score
					self.score = self.score + (brick.tier * 200 + brick.color * 25)

					-- trigger the brick's hit function, which removes it from play
					brick:hit()
				end
				
				-- if we have enough points, recover a point of health
				if self.score > self.recoverPoints and self.health < 3 then
					-- can't go above 3 health
					self.health = math.min(3, self.health + 1)

					-- multiply recover points by 2
					self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints)

					-- play recover sound effect
					gSounds['recover']:play()
				end
				
				-- if we have enough points, increase paddle size
				if self.score > self.paddleUpgradePoints and self.paddle.size < 4 then
					self.paddle:updateSize(1)
					self.paddleUpgradePoints = self.paddleUpgradePoints + math.min(100000, self.paddleUpgradePoints)
					gSounds['recover']:play()
				end

				-- go to our victory screen if there are no more bricks left
				if self:checkVictory() then
					gSounds['victory']:play()

					gStateMachine:change('victory', {
						level = self.level,
						paddle = self.paddle,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						ball = self.ball,
						recoverPoints = self.recoverPoints,
						paddleUpgradePoints = self.paddleUpgradePoints
					})
				end

				--
				-- collision code for bricks
				--
				-- we check to see if the opposite side of our velocity is outside of the brick;
				-- if it is, we trigger a collision on that side. else we're within the X + width of
				-- the brick and should check to see if the top or bottom edge is outside of the brick,
				-- colliding on the top or bottom accordingly 
				--

				-- left edge; only check if we're moving right, and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				if ballInstance.x + 2 < brick.x and ballInstance.dx > 0 then
					
					-- flip x velocity and reset position outside of brick
					ballInstance.dx = -ballInstance.dx
					ballInstance.x = brick.x - 8
				
				-- right edge; only check if we're moving left, , and offset the check by a couple of pixels
				-- so that flush corner hits register as Y flips, not X flips
				elseif ballInstance.x + 6 > brick.x + brick.width and ballInstance.dx < 0 then
					
					-- flip x velocity and reset position outside of brick
					ballInstance.dx = -ballInstance.dx
					ballInstance.x = brick.x + 32
				
				-- top edge if no X collisions, always check
				elseif ballInstance.y < brick.y then
					
					-- flip y velocity and reset position outside of brick
					ballInstance.dy = -ballInstance.dy
					ballInstance.y = brick.y - 8
				
				-- bottom edge if no X collisions or top collision, last possibility
				else
					
					-- flip y velocity and reset position outside of brick
					ballInstance.dy = -ballInstance.dy
					ballInstance.y = brick.y + 16
				end

				-- slightly scale the y velocity to speed up the game, capping at +- 150
				if math.abs(ballInstance.dy) < 150 then
					ballInstance.dy = ballInstance.dy * 1.02
				end

				if ballInstance.collideCount > POWER_UP_HITS then
					local whichPU = math.random(PU_MORE_BALLS,PU_BIG_PADDLE)
					local p = Powerup ( math.random(16, VIRTUAL_WIDTH-16), whichPU)
					table.insert(self.powerups, p)
					ballInstance.collideCount = 0
				end
				-- only allow colliding with one brick, for corners
				break
			end
		end

		-- if ball goes below bounds, revert to serve state and decrease health
		if ballInstance.y >= VIRTUAL_HEIGHT then
			table.remove(self.ballList, indx)
			if #self.ballList < 1 then
				self.health = self.health - 1
				self.paddle:updateSize(-1)
				gSounds['hurt']:play()

				if self.health == 0 then
					gStateMachine:change('game-over', {
						score = self.score,
						highScores = self.highScores
					})
				else
					gStateMachine:change('serve', {
						paddle = self.paddle,
						bricks = self.bricks,
						health = self.health,
						score = self.score,
						highScores = self.highScores,
						level = self.level,
						recoverPoints = self.recoverPoints,
						paddleUpgradePoints = self.paddleUpgradePoints
					})
				end
			end
		end
	end
	
	-- update powerups
	for key,pu in pairs(self.powerups) do
		pu:update(dt)
		
		if pu:collides(self.paddle) then
			gSounds['recover']:play()
			if pu.power == PU_MORE_BALLS then
				local b1 = Ball(self.ball.skin)
				b1.x = self.paddle.x
				b1.y = self.paddle.y - 8
				b1.dx = math.random(-200, 200)
				b1.dy = math.random(-50, -60)
				table.insert(self.ballList, b1)
				local b2 = Ball(self.ball.skin)
				b2.x = self.paddle.x + self.paddle.width
				b2.y = self.paddle.y - 8
				b2.dx = math.random(-200, 200)
				b2.dy = math.random(-50, -60)
				table.insert(self.ballList, b2)
			elseif pu.power == PU_SMALL_PADDLE then
				self.paddle:updateSize(-1)
			elseif pu.power == PU_BIG_PADDLE then
				self.paddle:updateSize(1)
			elseif pu.power == PU_KEY then
				self.unlockedTime = TIME_FOR_UNLOCK
			end
			table.remove(self.powerups, key)
		end
	end 
	
    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    for k, ballInstance in pairs(self.ballList) do
        ballInstance:render()
    end
	
	for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    renderScore(self.score, self.recoverPoints, self.paddleUpgradePoints )
    renderHealth(self.health)
	if self.unlockedTime > 0 then
		love.graphics.setFont(gFonts['small'])
		local timeleft = math.floor(self.unlockedTime * 100 + 0.5) / 100;
		love.graphics.printf('Bricks unlocked for ' .. tostring(timeleft), (VIRTUAL_WIDTH / 2)-75, VIRTUAL_HEIGHT - 15, 150, 'center')
	end
    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end