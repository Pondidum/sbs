local addon, ns = ...

local LibSetup = {
	
	new = function()

		local lib = {}

		lib.stats = ns.bidderStatistics
		lib.bidHandler = ns.bidHandler
		lib.bidMaster = ns.bidMaster
		lib.chatListener = ns.chatListener
		lib.itemCache = ns.itemCache
		lib.looter = ns.looter
		lib.notifier = ns.notifier 
		lib.raidRoster = ns.raidRoster
		
		return lib

	end,

}

sbmLib = LibSetup.new() 	--global for other addons
