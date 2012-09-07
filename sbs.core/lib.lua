local addon, ns = ...


local lib = {
	
	new = function()

		local this = {}

		this.parser = ns.NoteParser
		this.events = ns.Events.new()
		this.timer = ns.Timer
		this.roster = ns.RosterData.new()
		
		return this

	end,

}

ns.lib = lib.new()

sbsLib = ns.lib 	--global for other addons