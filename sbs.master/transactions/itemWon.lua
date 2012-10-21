local addon, ns = ...

ns.points.transactions.itemWon = function(user, points, itemData)

	local this = ns.points.newTransaction("Item Win: " .. itemData.name)

	this.addDescription(string.format("%s: -%d.", user.name, points))

	this.commit = function()
		user.points = user.points + points
	end

	this.rollback = function()
		user.points = user.points - points
	end

	return this
	
end