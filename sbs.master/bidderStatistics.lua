local addon, ns = ... or {}, {}

local BidderStatistics = {
	
	new = function(bidders)

		local bidders = bidders
		
		local byBid = {}
		local ranks = ns.config.ranks

		local this = {}


		this.getWinners = function(count)
		
			count = count or 1 

			-- no winners
			if #users == 0 then
				return {}
			end

			local winners = {}

			for i, entry in ipairs(byBid) do 

				if #winners == count then
					break
				end

				local points = entry.points
				local users = entry.users

				if #users == 1 then		--one person in this point category

					table.insert(winners, users[1])

				elseif #users <= count - #winners then	--everyone in this point category wins

					for j, user in ipairs(users) do
						table.insert(winners, user])
					end

				else 	--some people will win

				end


			end



			-- return top x, where x == bidItem.count
			-- handle 2 users with same weightedPoints

		end

		local onCreate = function()

			--create weightedPoints, mainspec > offspec | unranked
			for user, data in pairs(bidders) do
				data.weightedPoints = data.points / ranks[data.rank]
			end

			local sets = {}

			--group by weightedPoints 
			for name, bidData in pairs(bidders) do
				
				if sets[bidData.weightedPoints] == nil then
					sets[bidData.weightedPoints] = {}
				end

				table.insert(sets[bidData.weightedPoints], bidData)

			end

			--copy to byBid, sorting by points h -> l
			for points, users in pairs(sets) do
				table.insert(byBid, { points = points, users = users})
			end

			table.sort(byBid, function(a, b) return a.points > b.points end)

		end

		onCreate()
		return this 

	end,
}

ns.BidderStatistics = BidderStatistics


--test code:

ns.config = {
	ranks = { 
		mainspec = 1,
		offspec = 2.25,
		unranked = 2.25,
	},
}

local bidders = {
	["darkend"] = { name = "darkend", points = 15, rank = "mainspec"},
	["ayiishi"] = { name = "ayiishi", points = 15, rank = "mainspec"},
	["frenca"] = { name = "frenca", points = 13, rank = "offspec"},
}
