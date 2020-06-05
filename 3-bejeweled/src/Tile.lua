--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
	self.isShiny = math.random(10) == 1 and true or false
	if self.isShiny then
		
		self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 3)
		self.psystem:setParticleLifetime(.5, 1)
		self.psystem:setEmissionRate(math.random(2))
		self.psystem:setColors(255, 255, 255, 255,
								255, 255, 255, 150)
		self.psystem:setSizes(.2, 2)
		self.psystem:setSpin(0, 15)
		self.psystem:setAreaSpread('normal', 5, 5)
		self.psystem:setSpeed(.1,2)
	end
end

function Tile:update(dt)
    if self.isShiny then
		self.psystem:update(dt)
	end
end

function Tile:render(x, y, dt)
    
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
	
	--display numbers for color
	--love.graphics.setColor(255, 255, 255, 255)
    --love.graphics.setFont(gFonts['small'])
    --love.graphics.printf(tostring(self.color), self.x + x+16, self.y + y+16, 20, 'center')
		
	if self.isShiny then
		love.graphics.draw(self.psystem, self.x + x + 16, self.y + y + 16)
	end
end