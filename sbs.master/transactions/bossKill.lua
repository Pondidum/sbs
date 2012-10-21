local addon, ns = ...

ns.points.transactions.bossKill = function(users, points, bossName)
	
	local this = ns.points.newTransaction(string.format("Boss Kill: %s", bossName))

	for i, user in ipairs(users) do
		this.addDescription(string.format("%s: +%d.", user.name, points))
	end
	

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