local addon, ns = ...


local lib = {
	
	new = function()

		ns.lib = {}

		ns.lib.parser = ns.NoteParser
		ns.lib.events = ns.EventSource.new()
		ns.lib.timer = ns.Timer
		ns.lib.roster = ns.RosterData.new()
		
		return ns.lib

	end,

}



sbsLib = lib.new() 	--global for other addons
