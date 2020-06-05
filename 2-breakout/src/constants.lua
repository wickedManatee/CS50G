--[[
    GD50 2018
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
PADDLE_SPEED = 200

-- number of hits to spawn a power up
POWER_UP_HITS = 5 --25

-- time elapsed until a key spawns
KEY_SPAWN_TIME = 5 --30
-- time allowed to hit locked bricks
TIME_FOR_UNLOCK = 15

-- start the game at level
START_LEVEL = 43 -- 1

-- defining constants for powerups
PU_MORE_BALLS = 1
PU_SMALL_PADDLE = 2
PU_BIG_PADDLE = 3
PU_KEY = 4
