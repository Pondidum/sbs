local addon, ns = ...

local PriorityDecider = {
	
	new = function()

		local this = {}

		this.getPriority = function(user, item, requestedPrio)

			local requestedPrio = requestedPrio or "mainspec"

			local userClass = user.classFile
			local userMain = user.spec
			local userOff = user.offspec

			if item.priorities["all"] then

				return requestedPrio

			elseif item.priorities[userClass] then

				local classPrio = item.priorities[userClass]

				if classPrio["all"] then

					return requestedPrio

				elseif classPrio[userMain] then

					return requestedPrio

				elseif classPrio[userOff] then

					return "offspec"

				else

					return "unranked"

				end

			else

				return "unranked"

			end


		end

		return this

	end,

}

ns.priorityDecider = PriorityDecider.new()
--[[
local testDecider = PriorityDecider.new()

local testCases = {
	["when all specs are allowed"] = {
		args = {
			[1] = { classFile = "SHAMAN", spec = "ENHANCEMENT", offspec = "ELEMENTAL"},
			[2] = { priorities = { all = true } },
			[3] = "mainspec",
		},
		result = "mainspec",
	},
	["when all specs are allowed and offspec requested"] = {
		args = {
			[1] = { classFile = "SHAMAN", spec = "ENHANCEMENT", offspec = "ELEMENTAL"},
			[2] = { priorities = { all = true } },
			[3] = "offspec",
		},
		result = "offspec"
	},
	["when mainspec requested and item is available"] = {
		args = {
			[1] = { classFile = "SHAMAN", spec = "ENHANCEMENT", offspec = "ELEMENTAL"},
			[2] = { priorities = { SHAMAN = { ENHANCEMENT = true } } },
			[3] = "mainspec",
		},
		result = "mainspec"
	},
	["when offspec requested and item is available"] = {
		args = {
			[1] = { classFile = "SHAMAN", spec = "ENHANCEMENT", offspec = "ELEMENTAL"},
			[2] = { priorities = { SHAMAN = { ENHANCEMENT = true } } },
			[3] = "mainspec",
		},
		result = "mainspec"
	},
	["when mainspec requested and item is offspec available"] = {
		args = {
			[1] = { classFile = "SHAMAN", spec = "ENHANCEMENT", offspec = "ELEMENTAL"},
			[2] = { priorities = { SHAMAN = { ELEMENTAL = true } } },
			[3] = "mainspec",
		},
		result = "offspec"
	},
	["when offspec requested and item is offspec available"] = {
		args = {
			[1] = { classFile = "SHAMAN", spec = "ENHANCEMENT", offspec = "ELEMENTAL"},
			[2] = { priorities = { SHAMAN = { ELEMENTAL = true } } },
			[3] = "offspec",
		},
		result = "offspec"
	}
}



for name, case in pairs(testCases) do
	
	local result = testDecider.getPriority(unpack(case.args))

	if result == case.result then
		print("Pass:", name)
	else
		print("Fail:", name, "expected=", case.result, "actual=", result)
	end 

end
]]