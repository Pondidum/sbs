local addon, ns = ...

local BidHandler = {
	
	new = function()

		--local config, notifier, userData, pointsLog = ns.config, ns.notifier, ns.userData, ns.pointsLog

		local notifier = ns.notifier
		local userData = ns.lib.guildRoster
		local raidData = ns.raidRoster

		local timer = ns.lib.timer

		local ranks = { 
			mainspec = 1,
			offspec = 2.25,
			unranked = 2.25,
		}

		local this = {}
		local timer = timer.new("bidMaster")
		local bidders = {}
		local bidItem = {}
		local cancelling = false
		
		this.unregisterBid = function(name)

			if timer.isRunning() == false then
				return 
			end

			if bidders[name] then

				bidders[name] = nil
				notifier.sendBidCancelledSuccess(name)

			else
				notifier.sendBidCancelledFail(name)				
			end

		end


		this.registerBid = function(name, bid, rank)

			if timer.isRunning() == false then
				return 
			end

			if type(bid) ~= "number" then
				notifier.sendBidInvalid(name, bid)
				return
			end

			if rank == nil or rank == '' then
				rank = "mainspec"
			end

			rank = string.lower(rank)
			bid = tonumber(bid)
			
			if not ranks[rank] then
				notifier.sendBidInvalid(name, rank)
				return
			end

			local user = userData.getPlayerData(name)

			local previousBid = bidders[user]
 			local newBid = { points = bid, rank = rank, name = user.name }

			if user.points < bid then
				notifier.sendBidNotEnoughPoints(user, newBid, user.points)
				return
			end

 			bidders[user.name] = newBid

 			if previousBid then
 				notifier.sendBidUpdate(user.name, newBid)
 			else
 				notifier.sendBid(user.name, newBid)
 			end

 			if not timer.hasBeenExtended then
 				timer.extend()
 			end

		end
		

		local decideWinners = function()

			local stats = ns.bidderStatistics.new(bidders)

			local winners =  stats.getWinners(bidItem.count)
			local winnerNames = {}

			for i, user in ipairs(winners) do
				winnerNames[user.name] = true
			end

			local others = {}

			for name, bid in pairs(bidders) do
				
				if not winnerNames[name] then
					table.insert(others, name)
				end

			end
			
			return winners, others

		end

		local onFinish = function()

			if cancelling then
				notifier.broadcastBidCancelled()
				return
			end

			local winners, others = decideWinners()

			for i, winner in ipairs(winners) do
				
				local user = userData.getPlayerData(winner.name)
				
				user.points = user.points - winner.points

				userData.setPlayerData(user)
				--pointsLog.append(user)

			end

			notifier.broadcastBidFinished(bidItem, winners, others)
			notifier.broadcastPointsChanged(userData)

		end

		this.startBid = function(item)

			if timer.isRunning() then
				return 
			end

			cancelling = false

			bidItem = item
			bidders = {}
			timer.start(onFinish)

			notifier.broadcastBidStarted(item)

		end


		this.finishBid = function()
			cancelling = false
			timer.finish()
		end

		this.cancelBid = function()
			cancelling = true
			timer.finish()
		end

		return this

	end,

}


ns.lib.bid = BidHandler