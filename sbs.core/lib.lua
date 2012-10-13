local addon, ns = ...

local lib = {
	
	new = function()

		ns.lib = {}

		ns.lib.parser = ns.NoteParser
		ns.lib.events = ns.EventSource.new()
		ns.lib.timer = ns.Timer
		ns.lib.guildRoster = ns.GuildRosterData
		ns.lib.builder = ns.uiBuilder
		ns.lib.chatListener = ns.chatListener
		ns.lib.media = ns.media

		ns.lib.print = function(...)
			print("|cff33ff99sbs:|r", ...)
		end

		return ns.lib

	end,

}

sbsLib = lib.new() 	--global for other addons
