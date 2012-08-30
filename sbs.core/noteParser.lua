local NoteParser = {
	Parse = function(note, officernote)

		local spec = note
		local offspec = nil

		if note:find("%[.+%]") then
			spec, offspec = select(3, note:find("(.*)%[(.+)%]"))
		end

		if spec == nil or spec == '' then
			spec = "No Spec"
		end

		local tag, points = select(3,officernote:find("(!.*)%s(-*%d+)"))

		return spec, offspec, tag, points

	end,
}
