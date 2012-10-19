local addon, ns = ...

ns.points.transactions.itemReassign = function(fromUser, fromPoints, toUser, toPoints, itemLink)
	
	local this = ns.points.newTransaction("Item Reassign: " .. item.name)

	this.addDescription(string.format("%s: +%d.", fromUser.name, fromUser))
	this.addDescription(string.format("%s: -%d.", toUser.name, toPoints))


	this.commit = function()
		fromUser.points = fromUser.points + fromUser
		toUser.points = toUser.points - toPoints
	end

	this.rollback = function()
		fromUser.points = fromUser.points - fromUser
		toUser.points = toUser.points + toPoints
	end

end