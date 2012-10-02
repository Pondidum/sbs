local addon, ns = ...
local events = ns.lib.events

local ChatListener = {
	
	new = function(filter, onReceive, onReject)

		local filter = filter
		local onReceive = assert(onReceive, "arg2: You must provide an onReceive handler")
		local onReject = onReject or function() end

		local this = {}

		local onWhisper = function(self, event, message, sender, language, channelString, target, flags, unknownFirst, channelNumber, channelName, unknownSecond, counter, guid)

			if filter ~= nil and not string.find(message, filter) then
				onReject(sender, message, filter)
				return
			end

			onReceive(sender, message)

		end

		this.startListening = function()
			events.registerFor("CHAT_MSG_WHISPER", onWhisper, "sbs.master.chatlistener")
		end

		this.stopListening = function()
			events.unregisterFor("CHAT_MSG_WHISPER", "sbs.master.chatlistener")
		end
		


		return this

	end,

}

ns.chatListener = ChatListener