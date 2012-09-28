local addon, ns = ...

local Looter = {
	
	new = function()

		local notifier = ns.notifier

		local this = {}
		local uniqueItems = {}

		local createItem = function(itemLink, texture)

			--http://www.wowwiki.com/ItemLink
			local index, length, color, ltype, id = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+)")

			return {
				id = id,
				count = 1,
				name = GetItemInfo(id),
				link = itemLink,
				texture = texture,
			}

		end

		local readLoot = function()
						
			for i = 1, GetNumLootItems() do

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

		this.addLoot = function()
			readLoot()
		end

		this.loadLoot = function()

			uniqueItems = {}
			readLoot()
			
		end

		this.listIDs = function()

			local ids = {}

			for k,v in pairs(uniqueItems) do
				table.insert(ids, k)
			end

			return ids

		end

		this.report = function()

			for k,v in pairs(uniqueItems) do
				ns.lib.print(v.link, "x"..v.count)
			end

		end

		return this

	end,
}

ns.looter = Looter.new()
ns.lib.looter = ns.looter
