local addon, ns = ...

local ItemCache = {
	
	new = function()

		local events = ns.lib.events 

		local this = {}
		
		this.getItemInfo = function(itemID)

			if sbsMasterDatabase.items[itemID] then
				return sbsMasterDatabase.items[itemID]
			end

			return {}

		end

		this.addItem = function(item)

			sbsMasterDatabase.items[itemID] = item

		end

		return this

	end,
}

ns.ItemCache = ItemCache
