/datum/program/builtin/messenger
	name = "Messenger"
	var/datum/tablet_data/conversation/active_chat = null
	var/mob/living/user/spamcheck

	ViewApp()
		. = "<h2>Network Messenger</h2>"
		if(!tablet.messengeron)
			. += "<a href='byond://?src=\ref[src];choice=ToggleMessenger'>[tablet.messengeron ? "Messenger: On" : "Messenger: Off"]</a>"
			. += " <a href='byond://?src=\ref[src];choice=Sounds'>[tablet.silent ? "Sound: Off" : "Sound: On"]</a><br>"
			. += " <a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a><br>"
			return

		if(!network)
			. += "ERROR: No connection found"
			return

		else
			var/list/users_online = list()
			. += "<a href='byond://?src=\ref[src];choice=ToggleMessenger'>[tablet.messengeron ? "Messenger: On" : "Messenger: Off"]</a>"
			. += " <a href='byond://?src=\ref[src];choice=Sounds'>[tablet.silent ? "Sound: Off" : "Sound: On"]</a><br>"
			. += " <a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a><br>"
			if(active_chat)
				. += "<h3><a href='byond://?src=\ref[src];choice=Change Title'>[active_chat.name]</a> - [active_chat.users.len] users in this chat</h3>"
				. += "<a href='byond://?src=\ref[src];choice=Message'>Message</a> "
				. += "<a href='byond://?src=\ref[src];choice=Add Users'>Add User to Chat</a> "
				. += "<a href='byond://?src=\ref[src];choice=Send File'>Send File</a> "
				. += "<a href='byond://?src=\ref[src];choice=Minimize Chat'>Minimize Chat</a> "
				. += "<a href='byond://?src=\ref[src];choice=Leave Chat'>Leave</a>"
				. += "<div class='statusDisplay'>"
				. += "[active_chat.log]"
				. += "</div>"
				return
			. += "<h3>Active Conversations</h3>"
			for(var/datum/tablet_data/conversation/C in network.convos)
				if(C.users.Find(tablet))
					. += "<div class='statusDisplay'>"
					. += "[C.name]<br>"
					. += "Last Message: [C.lastmsg]<br>"
					. += "<a href='byond://?src=\ref[src];choice=Open Chat;target=\ref[C]'>Open</a><br>"
					. += "</div>"
			for(var/obj/item/device/tablet/T in sortNames(all_tablets))
				if(T == tablet) continue
				if(tablet.tablet2tablet(T))
					users_online.Add(T)
			. += "<h3>Users Online</h3>"
			. += "<div class='statusDisplay'>"
			for(var/obj/item/device/tablet/T in users_online)
				. += "[T.owner] ([T.ownjob]) - <a href='byond://?src=\ref[src];choice=Start Chat;target=\ref[T]'>Chat</a><br>"
			. += "</div>"

	CommandApp(href, href_list)
		switch(href_list["choice"])
			if("Start Chat")
				var/mob/living/U = usr
				var/t = stripped_input(U, "Please enter message", name, null, MAX_MESSAGE_LEN)
				if (!t || !tablet.messengeron)
					return
				if(!U.canUseTopic(tablet))
					return
				if(tablet.emped)
					t = Gibberish(t, 100)

				if(!t)
					return

				var/datum/tablet_data/conversation/chat = null

				if(locate(href_list["target"]))
					chat = locate(href_list["target"])
				else
					chat = active_chat
				if(!chat.users.Find(tablet))
					return

				chat.log += "[tablet.owner] ([tablet.ownjob]): [t]<br>"
				chat.raw_log += "[tablet.owner] ([tablet.ownjob]): [t]<br>"
				chat.lastmsg = "[tablet.owner] ([tablet.ownjob]): [t]"
				log_pda("[usr.key] (Tablet: [tablet.owner]) messaged \"[t]\" in chat: [chat.name]")
				if(chat.users.len > 2)
					for(var/obj/item/device/tablet/T in chat.users)
						if(T == tablet) continue
						if(!T.messengeron) continue
						for(var/datum/program/builtin/messenger/M in T.core.programs)
							T.alert_self("Messenger:","<b>Message in [chat.name] by [tablet.owner], </b>\"[t]\" <a href='byond://?src=\ref[M];choice=Message;target=\ref[chat]'>Reply</a>","messenger")
							break
				else
					for(var/obj/item/device/tablet/T in chat.users)
						if(T == tablet) continue
						if(!T.messengeron) continue
						for(var/datum/program/builtin/messenger/M in T.core.programs)
							T.alert_self("Messenger:","<b>Message from [tablet.owner], </b>\"[t]\" <a href='byond://?src=\ref[M];choice=Message;target=\ref[chat]'>Reply</a>","messenger")
							break

				for(var/mob/M in player_list)
					if(isobserver(M) && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTPDA))
						var/link = FOLLOW_LINK(M, U)
						M << "[link] <span class='name'>[tablet.owner] </span><span class='game say'>Tablet Message - \[<span class='name'>[chat.name]</span>\] <span class='name'>[tablet.owner]</span>: <span class='message'>[t]</span></span>"