local addon, ns = ...

local GuildRosterData = {
	
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

		this.loadPoints = function(ranks, raidMembers)

			GuildRoster()
			playerData = {}

			local loadedCount = 0

			for i = 1, GetNumGuildMembers() do

				local name, rank, rankIndex, level, class, zone, note, officernote = GetGuildRosterInfo(i)
				local spec, offspec, tag, points = noteParser.parse(note, officernote)

				if ranks == nil or ranks[rank] then

					if raidMembers == nil or raidMembers[name] then

						loadedCount = loadedCount + 1

						playerData[name] = {
							name 	= name,
							rank 	= rank,
							class	= class,
							spec 	= spec 	  or defaults.spec,
							offspec = offspec or defaults.offspec,
							tag 	= tag 	  or defaults.tag,
							points 	= points  or defaults.points,
						}

					end

				end
					
			end

			ns.lib.print(string.format("%d player's points loaded.", loadedCount))

		end

		this.savePoints = function()

			GuildRoster()
			local savedCount = 0

			for i = 1, GetNumGuildMembers() do

				local name = GetGuildRosterInfo(i)
				local data = playerData[name]

				if data then 

					local public, officer = noteParser.create(data.spec, data.offspec, data.tag, data.points) 

					GuildRosterSetPublicNote(i, public)
					GuildRosterSetOfficerNote(i, officer)

					savedCount = savedCount + 1

				end

			end

			ns.lib.print(string.format("%d player's points saved.", savedCount))

		end

		this.getPlayerData = function(name)

			local data = playerData[name]

			if data == nil then
				return nil
			end
			
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

		this.addPoints = function(amount)

			if amount == 0 then
				return
			end

			local boundaries = ns.config.bounds

			for name, data in pairs(playerData) do

				for i,bound in ipairs(ns.config.boundaries) do
					
					if data.points < bound.points then

						local newAmount = data.points + (amount * bound.factor)
						data.points = newAmount

						break
						
					end

				end

			end

		end

		return this

	end,

}

ns.GuildRosterData = GuildRosterData