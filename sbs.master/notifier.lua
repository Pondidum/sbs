
local Notifier = {}
Notifier.new = function()
		
	-- blizzard api
	local SendAddonMessage = SendAddonMessage
	local SendChatMessage = SendChatMessage



	local this = {}
	local prefix = "sbs_"

	local sendAddonMessage = function(tag, channel, target, message)

		if channel == "WHISPER" then
			SendAddonMessage(prefix .. tag, message, channel, target)
		else
			SendAddonMessage(prefix .. tag, message, channel)
		end 

	end

	local sendWhisperMessage = function(user, message)

		SendChatMessage(message, "WHISPER", nil, user)

	end

	local sendRaidMessage = function(message)
		SendChatMessage(message, "RAID", nil, nil)		
	end


	---------------------------------------------------------------------------

	this.sendBidCancelledSuccess = function(user) 
		sendWhisperMessage(user, "Bid cancelled.")
	end	

	this.sendBidCancelledFail = function(user) 
		sendWhisperMessage(user, "No bid to cancel.")
	end



	this.sendBidInvalid = function(user, bid)
		sendWhisperMessage(user, "Invalid bid %s.":format(bid))
	end

	this.sendBidNotEnoughPoints = function(user, newBid, available)
		sendWhisperMessage(user, "Not enough points (you bid %d, you have %d available.)":format(bid.points, available)
	end

	this.sendBid = function(user, newBid)
		sendWhisperMessage(user, "Bid accepted, %d points, %s.":format(newBid.points, newBid.rank))
	end

	this.sendBidUpdate = function(user, newBid) 
		sendWhisperMessage(user, "New bid accepted, %d points, %s.":format(newBid.points, newBid.rank))
	end



	this.broadcastBidStarted = function(item)
		sendAddonMessage("bs", "RAID", nil, item)

		local header = "Bid started on %s"

		if item.count > 1 then
			header = header .. " x%d"
		end

		sendRaidMessage( string.format(header, item.itemlink, item.count) )

		for i, ranked in ipairs(item.priorities) do
			
			local priorities = string.format("Rank %d: ", i)

			for j, rank in ipairs(ranked) do
				priorities = priorities .. string.format("%s %s, ", rank.spec, rank.class)
			end

			sendRaidMessage( string.sub(priorities, 1, #priorities - 2) )
		end
	
	end

	this.broadcastBidFinished = function(item, winners, runnersUp)
		sendAddonMessage("bf", "RAID", nil, item)
		--we are limited to 255 chars, so need to split sending

		local header = "Bid ended on %s"

		if item.count > 1 then
			header = header .. " x%d"
		end

		local winners = "Winners: "

		for i, winner in ipairs(winners) do
			winners = winners .. winner.name .. ", "
		end

		winners = string.sub(winners, 1, #winners - 2)

		local runners = "Runners up: "

		for i, person in ipairs(runnersUp) do
			runners = runners .. person.name .. ", "
		end

		runners = string.sub(runners, 1, #runners - 2)

		sendRaidMessage( string.format(header, item.itemlink, item.count) )
		sendRaidMessage( winners )
		sendRaidMessage( runners )

	end


	--singleton...
	Notifier.new = function() 
		return this 
	end

	return this

end