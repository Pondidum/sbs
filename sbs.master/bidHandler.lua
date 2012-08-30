
local BidHandler = {
	
	new = function(config, userData, pointsLog)

		local config, userData, pointsLog = config, userData, pointsLog

		local ranks = { 
			mainspec = true,
			offspec = true,
			unranked = true,
		}

		local this = {}
		local isBidRunning = false
		local bidders = {}
		
		this.cancelBid = function(user)

			if isBidRunning == false then
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

			if isBidRunning == false then
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

		end
		



		this.startBid = function(items)

			if isBidRunning then
				return 
			end

			bidders = {}
			-- store GetTime()

			isBidRunning = true

			notifier.broadcastBidStarted(items)

		end


		this.finishBid = function()

			if isBidRunning == false then
				return 
			end

			isBidRunning = false

			local winner = decideWinner()
			local user = userData[winner.name]

			user.points = user.points - winner.points

			pointsLog.append(user)

			notifier.broadcastBidFinished(winner, runnnersUp)
			notifier.broadcastPointsChanged(userData)

		end

		return this

	end,

}
