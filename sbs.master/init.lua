local addon, ns = ...

assert(sbsLib, "sbs.master was unable to load sbs.core.")
ns.lib = sbsLib

local events = ns.lib.events

local onAddonLoaded = function(sender, event, name)

	if name ~= "sbs.master" then
		return
	end

	events.unregsisterFor("ADDON_LOADED", "sbs.master.init.addonloaded")

	if sbsMasterDatabase == nil then
		sbsMasterDatabase = {}
		sbsMasterDatabase.items = {}
		sbsMasterDatabase.bosses = {}
	end

	if sbsMasterLog == nil then
		sbsMasterLog = {}
	end

end

events.registerFor("ADDON_LOADED", onAddonLoaded, "sbs.master.init.addonloaded")
