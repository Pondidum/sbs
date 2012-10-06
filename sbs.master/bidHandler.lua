local addon, ns = ...

local BidHandler = {
	
	new = function()

		local config   = ns.config
		local notifier = ns.notifier
		local lib      = ns.lib
		local userData = ns.lib.guildRoster
		local raidData = ns.raidRoster
		
		local timer = lib.timer.new("bidMaster")

		local this = {}
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

			local user = userData.getPlayerData(name)

			rank = string.lower(rank or "unranked")
			bid = tonumber(bid or 0)

			if user == nil then
				notifier.sendBidInvalidUser(name)
				return
			end

			if bid == nil then
				notifier.sendBidInvalid(user, bid)
				return
			end

			if bid < config.minbid then
				notifier.sendBidMinBid(user, config.minbid)
				return
			end

			if not config.ranks[rank] then
				notifier.sendBidInvalid(user, rank)
				return
			end

			local previousBid = bidders[user]
 			local newBid = { points = bid, rank = rank, name = user.name }

			if user.points < bid then
				notifier.sendBidNotEnoughPoints(user, newBid)
				return
			end

 			bidders[user.name] = newBid

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

ns.bidHandler = BidHandler
