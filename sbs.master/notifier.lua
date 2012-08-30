
local Notifier = {}
Notifier.new = function()
		
	-- blizzard api
	local SendAddonMessage = SendAddonMessage
	local SendChatMessage = SendChatMessage



	local this = {}
	local prefix = "sbs_bm"

	local sendAddonMessage = function(channel, target, message)

		if channel == "WHISPER" then
			SendAddonMessage(prefix, message, channel, target)
		else
			SendAddonMessage(prefix, message, channel)
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
		sendAddonMessage("RAID", nil, item)

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


	--singleton...
	Notifier.new = function() 
		return this 
	end

	return this

end