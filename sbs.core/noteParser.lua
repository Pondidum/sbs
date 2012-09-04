local addon, ns = ...

local NoteParser = {
	
	parse = function(note, officernote)

		local spec = note
		local offspec = nil

		if note:find("%[.+%]") then
			spec, offspec = select(3, note:find("(.*)%[(.+)%]"))
		end

		if spec == nil or spec == '' then
			spec = "No Spec"
		end

		local tag, points = select(3, officernote:find("(!.*)%s(-*%d+)"))

		return spec, offspec, tag, points

	end,

	create = function(spec, offspec, tag, points)

		local public = spec

		if offspec then
			public = "%s[%s]":format(spec, offspec)
		end

		local officer = "!%s %s":format(tag, points)

		return public, officer

	end,

}

ns.NoteParser = NoteParser