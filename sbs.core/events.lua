local addon, ns = ...

local EventSource = {
	
	new = function()

		local this = {}
		local events = {}
		local frame = CreateFrame("Frame")

		this.registerFor = function(event, handler, key)

			if not event then return end
			if not handler then return end 

			if not events[event] then
				events[event] = {}
				frame:RegisterEvent(event)
			end

			if handler and key then
				events[event][key] = handler
			else
				table.insert(events[event], handler)
			end

		end

		this.unregisterFor = function(event, key)

			if events[event] and events[event][key] then
				events[event][key] = nil
			end

		end

		local onEvent = function(self, event, ...)

			if events[event] then

				for _, handler in pairs(events[event]) do
					handler(self, event, ...)
				end

			end

		end

		frame:SetScript("OnEvent", onEvent)

		return this

	end,

}

ns.EventSource = EventSource