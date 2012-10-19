local addon, ns = ...

ns.points.transactions.bossKill = function(users, points, bossName)

	local this = ns.points.newTransaction(string.format("Boss Kill: %s", bossName))

	this.addDescription(string.format("Raid: +%d.", points))

	this.commit = function()

		for i, user in ipairs(users) do
			user.points = user.points + points
		end

	end

	this.rollback = function()

		for i,user in ipairs(users) do
			user.points = user.points - points
		end

	end

	return this

end