local addon, ns = ...

local lib = {
	
	new = function()

		ns.lib = {}

		ns.lib.parser = ns.NoteParser
		ns.lib.events = ns.EventSource
		ns.lib.timer = ns.Timer
		ns.lib.raidRoster = ns.raidRosterData
		ns.lib.guildRoster = ns.GuildRosterData
		ns.lib.builder = ns.uiBuilder
		ns.lib.chatListener = ns.chatListener
		ns.lib.media = ns.media
		ns.lib.minimap = ns.minimap

		ns.lib.print = function(...)
			print("|cff33ff99sbs:|r", ...)
		end

		return ns.lib

	end,

}

sbsLib = lib.new() 	--global for other addons
