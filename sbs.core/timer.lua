
local Timer = {
	
	new = function(events)

		local events = events

		local this = {}
		local finishTime = nil
		local active = false
		local onFinish = onFinish

		local SHORT_TIMER = 10
		local LONG_TIMER = 30

		-- Desc: Starts a timer for 10s
		-- Args: onFinish: A function to execute when the timer expires
		this.start = function(onFinish)
 
			finishTime = GetTime() + SHORT_TIMER
			active = true
			onFinish = onFinish

			events:RegisterOnUpdate("BidTimer", onUpdate)

		end

		-- Desc: Resets the timer for a further 30s
		-- Args:
		this.extend = function()

			finishTime = GetTime() + LONG_TIMER

		end

		-- Desc: Stops the timer
		-- Args:
		this.finish = function()
			active = false
		end


		local onUpdate = function()

			if active == false then
				events:UnRegisterOnUpdate("BidTimer", onUpdate)

				if onFinish then
					onFinish()
				end

				return
			end

			if GetTime() >= finishTime then
				active = false
			end

		end

		return this

	end,
}