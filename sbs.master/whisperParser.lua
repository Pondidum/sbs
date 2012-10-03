local addon, ns = ...

local WhisperParser = {
	
	parse = function(user, item, whisper)

		local bid, rank = 0, "unranked"
		

		local allRank = item.priorities["All"] or 50
		local classRank = 50
		local specRank = 50

		local classRanks = item.priorities[user.class]

		if classRanks then
			classRank = classRanks["All"] or 50
			specRank = classRanks[user.spec] or 50
		end

		local sorted = {allRank, classRank, specRank}
		table.sort(sorted)

		if sorted[1] == 1 then
			rank = "mainspec"
		elseif sorted[1] == 2 then
			rank = "offspec"
		else
			rank = "unranked"
		end


		return bid, rank

	end,

}

ns.whisperParser = WhisperParser


--[[
	item.priorities = {
		["SHAMAN"] = {
			["All"] = 2,
			["Enhancement"] = 1,
		},
		["All"] = 3
	}
]]

