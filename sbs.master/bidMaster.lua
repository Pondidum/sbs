local addon, ns = ...

local BidMaster = {
	
	new = function()

		local this = {}
		local frame = ns.BidMasterDesigner.new()
		
		local populateLoot = function()

			frame.LootList.clear()

			for i,v in ipairs(looter.listItems()) do
				
				

			end

		end,

		frame.LoadLoot:SetScript("OnClick", function()

			looter.loadLoot()
			populateLoot()

		end)

		frame.AddLoot:SetScript("OnClick", function()

			looter.addLoot()
			populateLoot()

		end)

		frame.CloseLoot:SetScript("OnClick", function()

			frame.LootList.clear()

		end)


		return this

	end,

}


--ns.bidMaster = BidMaster.new()