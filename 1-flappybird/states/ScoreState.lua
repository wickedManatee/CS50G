--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local BRONZE_STAR_IMAGE = love.graphics.newImage('starBronze.png')
local BRONZE_MIN = 2
local SILVER_STAR_IMAGE = love.graphics.newImage('starSilver.png')
local SILVER_MIN = 5
local GOLD_STAR_IMAGE = love.graphics.newImage('starGold.png')
local GOLD_MIN = 8

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
	if self.score >= BRONZE_MIN and self.score < SILVER_MIN then
		self.image = BRONZE_STAR_IMAGE --2, 3, 4
		self.nextMedal= 'Silver Medal at ' .. SILVER_MIN
	elseif self.score >= SILVER_MIN and self.score < GOLD_MIN then
		self.image = SILVER_STAR_IMAGE --5, 6,7
		self.nextMedal= 'Gold Medal at ' .. GOLD_MIN
	elseif self.score >= GOLD_MIN then
		self.image = GOLD_STAR_IMAGE -- 8+
	else
		self.nextMedal= 'Bronze Medal at ' .. BRONZE_MIN
	end
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
	
	if self.score >= BRONZE_MIN then
		love.graphics.draw(self.image, VIRTUAL_WIDTH /2 - self.image:getWidth() /2 , 130)
		love.graphics.printf('Press Enter to Play Again!', 0, 230, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
	end
    love.graphics.setFont(smallFont)	
		love.graphics.printf(self.nextMedal, 0, 115, VIRTUAL_WIDTH, 'center')
end