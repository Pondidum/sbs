local addon, ns = ...

ns.defaultKeyMeta = {
	__index = function(table, key)
		return table.default
	end,
}