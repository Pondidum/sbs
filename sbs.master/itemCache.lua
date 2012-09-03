local ItemCache = {
	
	new = function()

		local this = {}
		local items = {}	--saved vars, not sure if to explicit save/load

		this.getItemInfo = function(itemID)

			if items[itemID] then
				return items[itemID]
			end

			return {}

		end

		this.addItem = function(item)

			items[itemID] = item

		end

		

	end,
}