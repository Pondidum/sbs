
local BidHandler = {
	
	new = function(config, events, notifier, userData, pointsLog)

		local config, events, notifier, userData, pointsLog = config, events, notifier, userData, pointsLog

		local ranks = { 
			mainspec = true,
			offspec = true,
			unranked = true,
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


		this.registerBid = function(user, bid, prio)

			if timer.isRunning == false then
				return 
			end

			if type(bid) ~= "number" then
				notifier.sendBidInvalid(user, bid)
				return
			end

			if prio == nil or prio == '' then
				prio = "mainspec"
			end

			if not ranks[prio] then
				notifier.sendBidInvalid(user, prio)
				return
			end

			local previousBid = bidders[user]
 			local newBid = { points = bid, rank = prio }

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
		

		local decideWinner = function()

		end

		local onFinish = function()

			if timer.isRunning == false then
				return 
			end

			local winners = decideWinner()

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
