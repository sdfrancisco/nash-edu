-- A wrapper state, indicating that the tutorial is running.

function tutorial(prevState, params)
	local creatures = params.creatures
	local states = params.states

	state = "tutorial"
	drawBuf = {}

	local tracker = 0

	player = creatures.getCreature("player")
	enemy = creatures.getCreature("demoPentagon")
	enemy2 = creatures.getCreature("pentagon")

	if tracker == 0 then

		local page = 1
		local pages = {
			love.graphics.newImage"assets/1.png",
			love.graphics.newImage"assets/2.png",
			love.graphics.newImage"assets/3.png",
			love.graphics.newImage"assets/4.png",
			love.graphics.newImage"assets/5.png",
			love.graphics.newImage"assets/6.png",
			love.graphics.newImage"assets/7.png",
		}

		gui.mouse_events(X(80), Y(-40),
			-- Collider
			function(x, y, cx, cy)
					return cx > x and cx < x + S(100) and cy > y and cy < y + S(100)
			end,

			-- On hover
			function()
					drawBuf[#drawBuf + 1] = function()
							love.graphics.setColor(1, 1, 1, 0.3)
							love.graphics.rectangle("fill", X(80), Y(-40), S(100), S(100))
					end
			end,

			-- On click
			function()
					page = page - (page < 1)
			end,
			"tutorial"
		)

		gui.mouse_events(X(180), Y(-40),
			-- Collider
			function(x, y, cx, cy)
					return cx > x and cx < x + S(100) and cy > y and cy < y + S(100)
			end,

			-- On hover
			function()
					drawBuf[#drawBuf + 1] = function()
							love.graphics.setColor(1, 1, 1, 0.3)
							love.graphics.rectangle("fill", X(180), Y(-40), S(100), S(100))
					end
			end,

			-- On click
			function()
					page = page + (page > #pages)
			end,
			"tutorial"
		)

		-- raw drawing because of time crunch, TODO: improve
		local function drawFunc()
			for _, v in ipairs(drawBuf) do
				v()
			end
			if page < #pages then
					drawBuf = {function()
							love.graphics.draw(pages[page])

							love.graphics.setColor(0.4, 0.4, 0.4, 0.4)
							love.graphics.rectangle("fill", X(80), Y(-40), S(100), S(100))
							love.graphics.rectangle("fill", X(180), Y(-40), S(100), S(100))

							love.graphics.setColor(0.6, 0.6, 0.6, 0.6)
							love.graphics.rectangle("fill", X(80 + 2), Y(-40 - 2), S(100 - 4), S(100 - 4))
							love.graphics.rectangle("fill", X(180 + 2), Y(-40 - 2), S(100 - 4), S(100 - 4))

							love.graphics.setColor(0.75, 0.75, 0.75, 1)
							love.graphics.polygon("fill", X(100), Y(-90), X(160), Y(-60), X(160), Y(-120))
							love.graphics.polygon("fill", X(260), Y(-90), X(200), Y(-60), X(200), Y(-120))
					end}
			else
					-- self-deconstructing!
					gui.canvases["primary"].drawFunc = nil
					gui.canvases["primary"].enabled = false

					tracker = tracker + 1
			end

		end

		gui.canvases["primary"].drawfunc = drawFunc
		gui.canvases["primary"].enabled = true

	elseif tracker == 1 then
		state = "battle"

		states.battle(state, {
			party1 = player,
			party2 = enemy,
			initTutorial = true
		})

	elseif tracker == 2 then
		-- "Let's try a harder one"
		state = "battle"

		 states.battle(state, {
			party1 = player,
			party2 = enemy2,
		})
	else
		-- TODO: post-game information
	end

end

return tutorial
