
function table.join(self, separator, selector)

	if type(self) ~= "table" then
		assert("self must be a table")
	end

	separator = separator or ''
	selector = selector or function(val) return val end

	local result = ''

	for k, v in pairs(self) do
		result = result .. tostring(selector(v)) .. separator
	end

	return string.sub(result, 1, #result - #separator)

end


function table.print(t)
  
  print("{")
  
  for k, v in pairs(t) do
	print(string.format("  [%s]: %s", k, v))
  end
  
  print("}")

end


function table.clone(object)

    local lookup_table = {}
    
    local function _copy(object)
    
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table

        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end

        return setmetatable(new_table, getmetatable(object))
    end

    return _copy(object)

end
