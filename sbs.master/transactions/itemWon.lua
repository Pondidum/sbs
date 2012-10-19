local addon, ns = ...

ns.points.transactions.itemWon = function(user, points, itemLink)

	local this = ns.points.newTransaction("Item Win: " .. item.name)

	this.addDescription(string.format("%s: -%d.", user.name, points))

	this.commit = function()
		user.points = user.points + points
	end

	this.rollback = function()
		user.points = user.points - points
	end

	return this
	
end