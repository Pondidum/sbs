local addon, ns = ...

local GuildRosterData = {
	
	new = function()

		local noteParser = ns.lib.parser
		local loaded = false

		local this = {}
		local playerData = {}

		local defaults = {
			spec = "No Spec",
			offspec = "",
			tag = "X",
			points = 0,
			stored = 0,
		}

		this.loadPoints = function(ranks, raidMembers)

			if loaded then
				return
			end

			GuildRoster()
			playerData = {}

			local loadedCount = 0

			for i = 1, GetNumGuildMembers() do

				local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFile = GetGuildRosterInfo(i)
				local spec, offspec, tag, points = noteParser.parse(note, officernote)

				if ranks == nil or ranks[rank] then

					if raidMembers == nil or raidMembers[name] then

						loadedCount = loadedCount + 1

						playerData[name] = {
							name 		= name,
							rank 		= rank,
							class		= class,
							classFile 	= classFile,
							spec 		= spec 	  or defaults.spec,
							offspec 	= offspec or defaults.offspec,
							tag 		= tag 	  or defaults.tag,
							points 		= points  or defaults.points,
							stored  	= points  or defaults.stored,
						}

					end

				end
					
			end

			ns.lib.print(string.format("%d player's points loaded.", loadedCount))

		end

		this.reloadPoints = function()
			loaded = false
			this.loadPoints()
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

					data.stored = data.points
					savedCount = savedCount + 1

				end

			end

			ns.lib.print(string.format("%d player's points saved.", savedCount))

		end

		this.getPlayerData = function(name)
			return playerData[name]
		end

		this.addPoints = function(boundaries, amount)

			if amount == 0 then
				return
			end

			for name, data in pairs(playerData) do

				for i,bound in ipairs(boundaries) do
					
					if data.points < bound.points then

						local newAmount = data.points + (amount * bound.factor)
						data.points = newAmount

						break
						
					end

				end

			end

		end

		this.listPlayerData = function()

			local players = {}

			for k,v in pairs(playerData) do
				table.insert(players, v)
			end

			table.sort(players, function(x,y) return x.name < y.name end)
			return players

		end

		return this

	end,

}

ns.GuildRosterData = GuildRosterData