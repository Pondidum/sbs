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
		local LONG_TIMER = 30

		-- Desc: Starts a timer for 10s
		-- Args: onFinish: A function to execute when the timer expires
		this.start = function(onFinish)
 
			finishTime = GetTime() + SHORT_TIMER
			active = true
			hasBeenExtended = false

			onFinish = onFinish

			events:RegisterOnUpdate(name, onUpdate)

		end

		-- Desc: Resets the timer for a further 30s
		-- Args:
		this.extend = function()
			finishTime = GetTime() + LONG_TIMER
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


		local onUpdate = function()

			if active == false then
				events:UnRegisterOnUpdate(name, onUpdate)

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

ns.Timer = Timer