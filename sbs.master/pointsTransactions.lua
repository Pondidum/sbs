local addon, ns = ...

local PointsTransactions = {
	

	new = function()

		local this = {}
		local transactions = {}

		this.add = function(action)
			transactions[timestamp] = action
			action.commit()
		end

		this.list = function(action)

			local results = {}

			for timestamp, transaction in pairs(transactions) do
				table.insert(results, transaction)
			end

			return results

		end

		this.save = function()

			for stamp, transaction in pairs(transactions) do
				sbsMasterLog[stamp] = transaction
			end

		end

		return this

	end,

	transactions = {},

	newTransaction = function(name)	
	
		local transaction =  {}
		
		transaction.timestamp = GetTime()
		transaction.name = name
		transaction.description = description
		transaction.commit = function() end
		transaction.rollback = function() end

		transaction.actionDescriptions = {}
		transaction.addDescription = function(action) 
			table.insert(transaction.actionDescriptions, action)
		end

		return transaction

	end
}

ns.points = PointsTransactions
