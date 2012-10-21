local addon, ns = ...

local Timer = {
	
	new = function(name)

		local name = name
		local events = ns.lib.events
		local this = {}

		local finishTime = nil
		local onFinish = nil

		local hasBeenExtended = false
		local active = false

		local SHORT_TIMER = 10
		local LONG_TIMER = 20

		local onUpdate = function()

			if active == false then
				events.unregisterOnUpdate(name)

				if onFinish then
					onFinish()
				end

				return
			end

			if GetTime() >= finishTime then
				active = false
			end

		end

		-- Desc: Starts a timer for 10s
		-- Args: onFinish: A function to execute when the timer expires
		this.start = function(onFinishHandler)
 
			finishTime = GetTime() + SHORT_TIMER
			active = true
			hasBeenExtended = false

			onFinish = onFinishHandler

			events.registerOnUpdate(name, onUpdate)

		end

		-- Desc: Resets the timer to finish at 30s from start
		-- Args:
		this.extend = function()
			finishTime = finishTime + (LONG_TIMER - SHORT_TIMER)
			hasBeenExtended = true
		end

		-- Desc: Stops the timer
		-- Args:
		this.finish = function()
			active = false
		end


		-- Desc: Returns if the timer is currently running
		-- Args: 
		this.isRunning = function()
			return active
		end

		-- Desc: Returns if the timer has been extended
		-- Args:
		this.hasBeenExtended = function()
			return hasBeenExtended
		end

		return this

	end,
}

ns.Timer = Timer