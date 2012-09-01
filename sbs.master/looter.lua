

local Looter = {
	
	new = function()


		local createItem = function(itemLink)

			--http://www.wowwiki.com/ItemLink
			local _, _, color, ltype, id, enchant, gem1, gem2, gem3, gem4, suffix, unique, linkLvl, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

			return {
				id = id,
				count = 1,
				name = name,
				link = itemLink,
			}

		end

		
	end,
}