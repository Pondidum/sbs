local addon, ns = ... or {}, {}

local BidderStatistics = {
	
	new = function(bidders)

		local bidders = bidders
		
		local byBid = {}
		local ranks = ns.config.ranks
		local messages = {}

		local this = {}


		this.getWinners = function(count)
		
			count = count or 1 

			-- no winners
			if #byBid == 0 then
				return {}
			end

			local winners = {}

			for i, entry in ipairs(byBid) do 

				if #winners == count then
					break
				end

				local points = entry.points
				local users = entry.users

				table.insert(messages, string.format("%d bidders at %d points: %s", #users, points, table.join(users, ", ", function(x) return x.name end)))

				if #users == 1 then		--one person in this point category

					table.insert(winners, users[1])

				elseif #users <= count - #winners then	--everyone in this point category wins

					for j, user in ipairs(users) do
						table.insert(winners, user)
					end

				else 	--some people will win					

					local remainingWins = count - #winners
					local potentialWinners = {}

					for j, user in ipairs(users) do
						table.insert(potentialWinners, user)
					end

					for c = 1, remainingWins do

						local index = math.random(1, #potentialWinners)
						
						local currentRollers = table.join(potentialWinners, ", ", function(x) return x.name end)
						table.insert(messages, string.format(" - Rolling 1-%d (%s): %d", #potentialWinners, currentRollers, index))

						table.insert(winners, potentialWinners[index])
						table.remove(potentialWinners, index)

					end

				end


			end

			return winners

		end

		this.getMessages = function()
			return messages
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
-------------------------------------------------------------------------------

function table.join(self, separator, selector)

	if type(self) ~= "table" then
		assert("self must be a table")
	end

	separator = separator or ''
	selector = selector or function(val) return tostring(val) end

	local result = ''

	for i, v in ipairs(self) do
		result = result .. selector(v) .. ", "
	end

	return string.sub(result, 1, #result - #separator)

end

ns.config = {
	ranks = { 
		mainspec = 1,
		offspec = 2.25,
		unranked = 2.25,
	},
}

local bidders = {
	["darkend"] = { name = "darkend", points = 4, rank = "mainspec"},
	["ayiishi"] = { name = "ayiishi", points = 4, rank = "mainspec"},
	["frenca"] = { name = "frenca", points = 9, rank = "offspec"},
	["somniac"] = { name = "somniac", points = 9, rank = "offspec"},
}


local bs = ns.BidderStatistics.new(bidders)
local w = bs.getWinners(3)

for i,v in ipairs(bs.getMessages()) do
	print(i,v)
end

print("winners:", #w)

for i,v in ipairs(w) do
	print(i,v.name)
end
