
local BidHandler = {
	
	new = function(config, events, notifier, userData, pointsLog)

		local config, events, notifier, userData, pointsLog = config, events, notifier, userData, pointsLog

		local ranks = { 
			mainspec = 1,
			offspec = 2.25,
			unranked = 2.25,
		}

		local this = {}
		local timer = Timer.new(events)
		local bidders = {}
		local bidItem = {}
		
		this.cancelBid = function(user)

			if timer.isRunning == false then
				return 
			end

			if bidders[user] then

				bidders[user] = nil
				notifier.sendBidCancelledSuccess(user)

			else
				notifier.sendBidCancelledFail(user)				
			end

		end


		this.registerBid = function(user, bid, rank)

			if timer.isRunning == false then
				return 
			end

			if type(bid) ~= "number" then
				notifier.sendBidInvalid(user, bid)
				return
			end

			if rank == nil or rank == '' then
				rank = "mainspec"
			end

			rank = string.lower(rank)

			if not ranks[rank] then
				notifier.sendBidInvalid(user, rank)
				return
			end

			local previousBid = bidders[user]
 			local newBid = { points = bid, rank = rank, name = user }

			if userData[user].points < bid then
				notifier.sendBidNotEnoughPoints(user, newBid, userData[user].points)
				return
			end

 			bidders[user] = newBid

 			if previousBid then
 				notifier.sendBidUpdate(user, newBid)
 			else
 				notifier.sendBid(user, newBid)
 			end

 			if not timer.hasBeenExtended then
 				timer.extend()
 			end

		end
		

		local decideWinners = function()

			if #bidders == 0 then
				return nil
			end

			--create weightedPoints, mainspec > offspec | unranked
			for user, data in pairs(bidders) do
				data.weightedPoints = data.points / ranks[data.rank]
			end

			-- sort the winners table based on weightedPoints
			local users = {}
			for user, _ in pairs(bidders) do
				table.insert(users, user)
			end

			table.sort(users, function(x, y) 
				return bidders[x].weightedPoints > bidders[y].weightedPoints
			end)

			if #bidders == 1 then
				for user, data in pairs(bidders) do
					return data 
				end
			end

			-- return top x, where x == bidItem.count
			-- handle 2 users with same weightedPoints

		end

		local onFinish = function()

			local winners = decideWinners()

			for i, winner in ipairs(winners) do
				
				local user = userData[winner.name]
				user.points = user.points - winner.points
				pointsLog.append(user)

			end

			notifier.broadcastBidFinished(bidItem, winners, runnnersUp)
			notifier.broadcastPointsChanged(userData)

		end

		this.startBid = function(item)

			if timer.isRunning then
				return 
			end

			bidItem = item
			bidders = {}
			timer.start(onFinish)

			notifier.broadcastBidStarted(item)

		end


		this.finishBid = function()
			timer.finish()
		end

		return this

	end,

}
