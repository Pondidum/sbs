local addon, ns = ...

local RosterData = {
	
	new = function()

		local config, noteParser = ns.config, ns.lib.parser

		local this = {}
		local playerData = {}

		local updatableFields = {
			spec = true,
			offspec = true,
			tag = true,
			points = true,
		}

		this.loadPoints = function()

			GuildRoster()

			for i = 1, GetNumGuildMembers() do

				local name, rank, _, _, _, _, note, officernote = GetGuildRosterInfo(i)

				if config.ranks[rank] then
					local spec, offspec, tag, points = noteParser.parse(note, officernote)

					playerData[name] = {
						name = name,
						spec = spec,
						offspec = offspec,
						tag = tag,
						points = points
					}

				end
				
			end

		end

		this.savePoints = function()

			GuildRoster()

			for i = 1, GetNumGuildMembers() do

				local name = GetGuildRosterInfo(i)
				local data = playerData[name]

				local public, officer = noteParser.create(data.spec, data.offspec, data.tag, data.points) 

				GuildRosterSetPublicNote(public)
				GuildRosterSetOfficerNote(officer)

			end

		end

		this.getPlayerData = function(name)
			return playerData[name]
		end

		this.setPlayerData = function(data)

			if not data then 
				return 
			end

			local player = playerData[data.name]
			
			if not player then
				return 
			end

			for key, val in pairs(updatableFields) do
				player[key] = data[key]	
			end

		end

		return this

	end,

}

ns.RosterData = RosterData