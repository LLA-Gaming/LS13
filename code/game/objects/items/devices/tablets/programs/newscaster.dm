/datum/program/newscaster
	name = "Newscaster"
	app_id = "newscaster"
	var/current_channel

	use_app()
		dat = "<h4>Newscaster Access</h4>"
		dat += "<br> Current Newsfeed: <A href='byond://?src=\ref[src];choice=Newscaster Switch Channel'>[current_channel ? current_channel : "None"]</a> <br>"
		var/datum/newscaster/feed_channel/current
		for(var/datum/newscaster/feed_channel/chan in news_network.network_channels)
			if (chan.channel_name == current_channel)
				current = chan
		if(!current)
			dat += "<h5> ERROR : NO CHANNEL FOUND </h5>"
			return
		var/i = 1
		for(var/datum/newscaster/feed_message/msg in current.messages)
			dat +="-[msg.returnBody(-1)] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[msg.returnAuthor(-1)]</FONT>\]</FONT><BR>"
			dat +="<b><font size=1>[msg.comments.len] comment[msg.comments.len > 1 ? "s" : ""]</font></b><br>"
			if(msg.img)
				usr << browse_rsc(msg.img, "tmp_photo[i].png")
				dat +="<img src='tmp_photo[i].png' width = '180'><BR>"
			i++
			for(var/datum/newscaster/feed_comment/comment in msg.comments)
				dat +="<font size=1><small>[comment.body]</font><br><font size=1><small><small><small>[comment.author] [comment.time_stamp]</small></small></small></small></font><br>"
		dat += "<br> <A href='byond://?src=\ref[src];choice=Newscaster Message'>Post Message</a>"



	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Newscaster Message")
				var/tablet_owner_name = "[tablet.owner] ([tablet.ownjob])"
				var/message = stripped_input(usr, "Please enter message", name, null) as text
				var/datum/newscaster/feed_channel/current
				for(var/datum/newscaster/feed_channel/chan in news_network.network_channels)
					if (chan.channel_name == current_channel)
						current = chan
				if(current.locked && current.author != tablet_owner_name)
					dat += "<h5> ERROR : NOT AUTHORIZED</h5>"
				else
					news_network.SubmitArticle(message,tablet.owner,current_channel)
			if("Newscaster Switch Channel")
				var/input = stripped_input(usr, "Please enter message", name, null) as text
				current_channel = input
		tablet.attack_self(usr)