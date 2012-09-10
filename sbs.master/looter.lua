local addon, ns = ...

local Looter = {
	
	new = function()

		local config, notifier = ns.config, ns.notifier

		local this = {}
		local items = {}

		local createItem = function(itemLink, texture)

			--http://www.wowwiki.com/ItemLink
			local _, _, color, ltype, id, enchant, gem1, gem2, gem3, gem4, suffix, unique, linkLvl, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

			return {
				id = id,
				count = 1,
				name = name,
				link = itemLink,
				texture = texture,
			}

		end

		local readLoot = function()
						
			for i = 1, GetNumLootItems()

				local link = GetLootSlotLink(i)
				local texture, item, quantity, quality, locked = GetLootSlotInfo(i)

				if link and quality >= 4 then		--4==epic

					local item = createItem(link, texture)

					if uniqueItems[item.id] then
						uniqueItems[item.id].count = uniqueItems[item.id].count + 1
					else
						uniqueItems[item.id] = item
					end

				end

			end

		end

		local addLoot = function()

			readLoot()
			notifier.broadcastLootUpdated(items)

		end
		this.addLoot = addLoot

		local loadLoot = function()

			local items = {}
			
			readLoot()
			notifier.broadcastLootUpdated(items)
			
		end
		this.loadLoot = loadLoot
		
	end,
}