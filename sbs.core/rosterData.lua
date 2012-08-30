
local RosterData = {
	
	New = function(config)

		local this = {}
		local playerData = {}

		local loadPoints = function()

			GuildRoster()

			for i = 1, GetNumGuildMembers() do

				local name, rank, _, _, _, _, note, officernote = GetGuildRosterInfo(i)

				if config.ranks[rank] then
					local spec, offspec, tag, points = NoteParser.Parse(note, officernote)

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
		this.LoadPoints = loadPoints

		local savePoints = function()

			GuildRoster()

			for i = 1, GetNumGuildMembers() do

				local name = GetGuildRosterInfo(i)
				local data = playerData[name]

				local public = data.spec

				if data.offspec then
					public = "%s[%s]":format(data.spec, data.offspec)
				end

				local officer = "!%s %s":format(data.tag, data.points)

				GuildRosterSetPublicNote(public)
				GuildRosterSetOfficerNote(officer)

			end

		end
		this.SavePoints = savePoints

		return this
	end,

}