
function table.join(self, separator, selector)

	if type(self) ~= "table" then
		assert("self must be a table")
	end

	separator = separator or ''
	selector = selector or function(val) return tostring(val) end

	local result = ''

	for i, v in ipairs(self) do
		result = result .. selector(v) .. ", "
	end

	return string.sub(result, 1, #result - #separator)

end


local test = {"123", "456", "789"}
local items = {
	{a=123, b=789},
	{a=456, b=456},
	{a=789, b=123},
}
print(table.join(items, ", ", function(x) return x.b end))