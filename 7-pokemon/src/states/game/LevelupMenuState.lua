LevelupMenuState = Class{__includes = BaseState}

function LevelupMenuState:init(pokemon, hp, atk, def, spd, callback)
	self.pokemon = pokemon
	self.callback = callback or function() end
	
    self.levelupMenu = Menu {
        x = VIRTUAL_WIDTH - 150,
        y = VIRTUAL_HEIGHT - 64,
        width = 150,
        height = 64,
        showCursor = 'false',
		items = {
            {
                text = 'HP ' .. self.pokemon.HP - hp .. ' + ' .. hp .. ' = ' .. self.pokemon.HP,
                onSelect = function() 
					self:selected()
				end
            },
			{
                text = 'ATK ' .. self.pokemon.attack - atk .. ' + ' .. atk .. ' = ' .. self.pokemon.attack,
                onSelect = function() 
					self:selected()
				end
            },
			{
                text = 'DEF ' .. self.pokemon.defense - def .. ' + ' .. def .. ' = ' .. self.pokemon.defense,
                onSelect = function() 
					self:selected()
				end
            },
			{
                text = 'SPD ' .. self.pokemon.speed - spd.. ' + ' .. spd .. ' = ' .. self.pokemon.speed,
                onSelect = function() 
					self:selected()
				end
            }
        }
    }
end

function LevelupMenuState:update(dt)
    self.levelupMenu :update(dt)
end

function LevelupMenuState:render()
    self.levelupMenu :render()
end

function LevelupMenuState:selected()
	gStateStack:pop()
	gStateStack:pop()
	self.callback() 
end
