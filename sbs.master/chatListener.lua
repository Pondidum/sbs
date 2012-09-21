local addon, ns = ...
local events = ns.events

local ChatListener = {
	
	new = function(filter, onReceive, onReject)

		local filter = filter
		local onReceive = assert(onReceive)
		local onReject = onReject or function() end

		local this = {}

		local onWhisper = function(message)

			if filter ~= nil and not message:find(filter) then
				onReject(filter, message)
				return
			end

			onReceive(message)

		end

		this.startListening = function()
			events.registerFor("CHAT_WHISPER_RECEIVED", onWhisper, "sbs.master.chatlistener")
		end

		this.stopListening = function()
			events.unregisterFor("CHAT_WHISPER_RECEIVED", "sbs.master.chatlistener")
		end
		


		return this

	end,

}

ns.chatListener = ChatListener
