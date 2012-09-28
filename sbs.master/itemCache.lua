local addon, ns = ...

local ItemCache = {
	
	new = function()

		local events = ns.lib.events 
		local this = {}
		
		this.getItemInfo = function(itemID)

			local info = sbsMasterDatabase.items[itemID]

			if info == nil then

				info = {
					link = "",
					priorities = {},
				}
				
				sbsMasterDatabase.items[itemID] = info

			end 

			return info

		end

		this.addItem = function(item)

			sbsMasterDatabase.items[itemID] = item

		end

		return this

	end,
}

ns.itemCache = ItemCache.new()
sbsLib.cache = ns.itemCache
