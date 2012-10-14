local addon, ns = ...
local events = ns.EventSource

local Settings = {

	new = function()  

		local this = {}
		local handlers = {}

		this.get = function(name)
			return sbsCoreSettings[name]
		end

		this.set = function(name, value)
			sbsCoreSettings[name] = value
		end
		
		this.onLoad = function(action) 
			table.insert(handlers, action)
		end


		local onAddonLoaded = function(sender, event, name)

			if name ~= "sbs.core" then
				return
			end

			events.unregisterFor("ADDON_LOADED", "sbs.core.settings.addonloaded")

			if sbsCoreSettings == nil then
				sbsCoreSettings = {}
			end

			for i,v in ipairs(handlers) do
				v()
			end

		end

		events.registerFor("ADDON_LOADED", onAddonLoaded, "sbs.core.settings.addonloaded")

		return this


	end,

}

ns.userSettings = Settings.new()