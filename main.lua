--[[
Functions must have a summary of the function's purpose and output (if any).
Ex:
function player_hp_display(cur, max) --Displays player hp to the screen.
	--code here--
end

--]]

local gui = require("src/gui")
local creatures = require("src/creatures")

local states = {
	tutorial = require("src/states/tutorial"),
	battle = require("src/states/battle"),
}
state = "main"

-- Function to use for the state machine.
-- (stateFunction, parameters{}) >> state, love -> return{}
stateFunction = function() end
stateParameters = {}

function love.load() --Place initializations here
	math.randomseed(os.time()) -- just to set it up
	w, h, s = 640, 360, 2
	success = love.window.setMode(w*s, h*s, {} )
	
	states.tutorial("main", {
		creatures = creatures,
		states = states,
	})

	-- stateFunction(stateFunction, stateParameters)
end

--[[ --TODO: rescale-friendly UI
function love.window.resize(w, h)
	gui.canvases.redraw()
end
]]
function love.draw()
	gui.canvases.draw()
end

function love.update(dt) --currently handles all GUI interfacing (other than the function below)
	gui.mouse_events.iter(state, love.mouse.getX(), love.mouse.getY())

end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		gui.mouse_events.iter(state, x, y, true, presses)
	end
end
