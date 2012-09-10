local addon, ns = ...

local RosterData = {
	
	new = function()

		local noteParser = ns.lib.parser

		local this = {}
		local playerData = {}

		local updatableFields = {
			spec = true,
			offspec = true,
			tag = true,
			points = true,
		}

		local defaults = {
			spec = "No Spec",
			offspec = "",
			tag = "X",
			points = 0,
		}

		this.loadPoints = function(ranks)

			GuildRoster()

			for i = 1, GetNumGuildMembers() do

				local name, rank, _, _, _, _, note, officernote = GetGuildRosterInfo(i)
				local spec, offspec, tag, points = noteParser.parse(note, officernote)

				if ranks == nil or ranks[rank] then

					playerData[name] = {
						name 	= name,
						rank 	= rank,
						spec 	= spec 	  or defaults.spec,
						offspec = offspec or defaults.offspec,
						tag 	= tag 	  or defaults.tag,
						points 	= points  or defaults.points,
					}

				end
					
			end

		end

		this.savePoints = function()

			GuildRoster()

			for i = 1, GetNumGuildMembers() do

				local name = GetGuildRosterInfo(i)
				local data = playerData[name]

				if data then 
					local public, officer = noteParser.create(data.spec, data.offspec, data.tag, data.points) 

					GuildRosterSetPublicNote(i, public)
					GuildRosterSetOfficerNote(i, officer)
				end

			end

		end

		this.getPlayerData = function(name)

			local data = playerData[name]
			local player = {}

			for key, val in pairs(data) do
				player[key] = data[key]	
			end

			return player
			
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