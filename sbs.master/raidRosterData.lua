local addon, ns = ...

local RaidRosterData = {
	
	new = function()

		local this = {}
		local raiders = {}

		this.loadRaid = function()

			for i = 1, GetNumGroupMembers() do

				local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

				raiders[name] = {
					name = name
				}

			end
			
		end

		this.getRaidMembers = function()

			local result = {}

			for k,v in pairs(raiders) do
				result[k] = true
			end

			return result

		end

		return this

	end,

}

ns.raidRoster = RaidRosterData.new()