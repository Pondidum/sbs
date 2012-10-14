local addon, ns = ...

local EventSource = {
	
	new = function()

		local this = {}
		local frame = CreateFrame("Frame")


		local events = {}
		local updates = {}		

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

		this.registerOnUpdate = function(key, handler) 

			updates[key] = handler

		end

		this.unregisterOnUpdate = function(key) 

			if updates[key] then
				updates[key] = nil
			end

		end


		frame:SetScript("OnEvent", function(self, event, ...)

			if events[event] then

				for key, handler in pairs(events[event]) do
					handler(self, event, ...)
				end

			end

		end)

		frame:SetScript("OnUpdate", function()
			
			for key, handler in pairs(updates) do
				handler()
			end

		end)

		return this

	end,

}

ns.EventSource = EventSource.new()