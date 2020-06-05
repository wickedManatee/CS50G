--[[
    Paused State
    Author: Will Mearns

    Allows the game to freeze in time. Transitions to the PlayState when player hits the required key.
	Currently not being used
]]

PauseState = Class{__includes = BaseState}

local PAUSE_IMAGE = love.graphics.newImage('pause.png')

function PauseState:init()
	sounds['pause']:play()
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play')
    end
end

function PauseState:render()
    -- render paused image big in the middle of the screen
    love.graphics.draw(PAUSE_IMAGE, VIRTUAL_WIDTH /2 - PAUSE_IMAGE:getWidth() /2 , 100)
end