
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
