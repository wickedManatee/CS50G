--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
		type = 'heart',
		texture = 'hearts',
		width = 16,
		height = 16,
		frame = 5,
		solid = false,
		defaultState = 'full',
        states = {
            ['full'] = {
                frame = 5
            },
			['empty'] = {
                frame = 1
            }
		}
	},	
	['pot'] = {
        type = 'pot',
		texture = 'tiles',
		width = 16,
		height = 16,
		frame = POTS[1],
		solid = true,
		defaultState = 'safe',
        states = {
            ['safe'] = {
                frame = POTS[1]
            },
			['broken'] = {
                frame = POTS_BROKEN[1]
            }
		}
    }
}