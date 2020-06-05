--[[
    GD50
    Breakout Remake

    -- ServeState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]

ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    -- grab game state from params
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints
	self.paddleUpgradePoints = params.paddleUpgradePoints
	self.powerups = {}

    -- init new ball (random color for fun)
    self.ball = Ball()
    self.ball.skin = math.random(7)
	self.levelWithLocks = checkForLocks(params.bricks)
end

function ServeState:update(dt)
    -- have the ball track the player
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

	if love.keyboard.wasPressed('q') then
		gStateMachine:change('paddle-select', {})
	end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- pass in all important state info to the PlayState
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball = self.ball,
            level = self.level,
			levelWithLocks = checkForLocks(self.bricks),
            recoverPoints = self.recoverPoints,
			paddleUpgradePoints = self.paddleUpgradePoints,
			powerups = self.powerups
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function checkForLocks(bricklist)
	for key, brickInst in pairs(bricklist) do
		if brickInst.isLocked then
		    return true
		end
	end
	return false
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score, self.recoverPoints, self.paddleUpgradePoints)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end