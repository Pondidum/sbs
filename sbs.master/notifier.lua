
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
		sendAddonMessage("bs", "RAID", nil, string.format("%s:%s:%s", item.id, item.name, item.link))

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

		local getName = function(p) return p.name end

		local addonWinners = table.join(winners, ":", getName)
		local addonBidders = table.join(runnersUp, ":", getName)

		sendAddonMessage("bf", "RAID", nil, string.format("%s:%s:%s", item.id, item.name, item.link))
		sendAddonMessage("bfw", "RAID", nil, string.format("%s:%s", item.id, addonWinners))
		sendAddonMessage("bfb", "RAID", nil, string.format("%s:%s", item.id, addonBidders))

		local header = "Bid ended on %s"

		if item.count > 1 then
			header = header .. " x%d"
		end

		local raidWinners = "Winners: " .. table.join(winners, ", ", getName)
		local raidBidders = "Runners up: " .. table.join(runnersUp, ", ", getName)

		sendRaidMessage(string.format(header, item.link, item.count))
		sendRaidMessage(raidWinners)
		sendRaidMessage(raidBidders)

	end


	--singleton...
	Notifier.new = function() 
		return this 
	end

	return this

endp