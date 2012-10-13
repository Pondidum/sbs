local addon, ns = ...
local designer = ns.pointsDisplayDesigner


local sbsPoints = {
	
	new = function()

		local pointsDisplay = designer.newDisplay()

		local points = {}
		local rows = {}

		local updatePoints = function()
			--populate from guild roster, or from a bid master points updated event.

			local guildRoster = ns.lib.guildRoster.new()
			guildRoster.loadPoints()		--gather from ui options later

			points = guildRoster.listPlayerData()

		end

		local getRow = function(index)

			local row = rows[index]

			if row == nil then
				row = designer.newRow("$parent$Row"..i, pointsDisplay.Table:GetName())
				rows[index] = row
			end

			return row

		end

		local updateDisplay = function()

			for i, player in ipairs(points) do

				local row = getRow(i)

				row.Name:SetText(player.name)
				row.Class:SetText(player.class)
				row.Spec:SetText(player.spec)
				row.Points:SetText(player.points)

				local color = RAID_CLASS_COLORS[player.classFile]

				row.Name:SetTextColor(color.r, color.g, color.b)

			end

			pointsDisplay.Table.populate(data)

		end

		pointsDisplay.Options.Refresh:SetScript("OnClick", function()  
			updatePoints()
			updateDisplay()
		end)

	end,
}
