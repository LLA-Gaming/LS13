/datum/program/bots
	name = "Bot Interlink"
	app_id = "bot_control"
	usesalerts = 1
	utility = 0
	drm = 1
	var/mob/living/simple_animal/bot/active_bot
	var/list/botlist = list()

	use_app()
		dat = "<h4>Bots Interlink</h4>"
		var/mob/living/simple_animal/bot/Bot

		if(active_bot)
			dat += "<B>[active_bot]</B><BR> Status: (<A href='byond://?src=\ref[src];op=control;bot=\ref[active_bot]'><img src=pda_refresh.png><i>refresh</i></A>)<BR>"
			dat += "Model: [active_bot.model]<BR>"
			dat += "Location: [get_area(active_bot)]<BR>"
			dat += "Mode: [active_bot.get_mode()]"
			if(active_bot.allow_pai)
				dat += "<BR>pAI: "
				if(active_bot.paicard && active_bot.paicard.pai)
					dat += "[active_bot.paicard.pai.name]"
					if(active_bot.bot_core.allowed(usr))
						dat += " (<A href='byond://?src=\ref[src];op=ejectpai'><i>eject</i></A>)"
				else
					dat += "<i>none</i>"

			//MULEs!
			if(active_bot.bot_type == MULE_BOT)
				var/mob/living/simple_animal/bot/mulebot/MULE = active_bot
				var/atom/Load = MULE.load
				dat += "<BR>Current Load: [ !Load ? "<i>none</i>" : "[Load.name] (<A href='byond://?src=\ref[src];mule=unload'><i>unload</i></A>)" ]<BR>"
				dat += "Destination: [MULE.destination ? MULE.destination : "<i>None</i>"] (<A href='byond://?src=\ref[src];mule=destination'><i>set</i></A>)<BR>"
				dat += "Set ID: [MULE.suffix] <A href='byond://?src=\ref[src];mule=setid'><i> Modify</i></A><BR>"
				dat += "Power: [MULE.cell ? MULE.cell.percent() : 0]%<BR>"
				dat += "Home: [!MULE.home_destination ? "<i>none</i>" : MULE.home_destination ]<BR>"
				dat += "Delivery Reporting: <A href='byond://?src=\ref[src];mule=report'>[MULE.report_delivery ? "(<B>On</B>)": "(<B>Off</B>)"]</A><BR>"
				dat += "Auto Return Home: <A href='byond://?src=\ref[src];mule=autoret'>[MULE.auto_return ? "(<B>On</B>)": "(<B>Off</B>)"]</A><BR>"
				dat += "Auto Pickup Crate: <A href='byond://?src=\ref[src];mule=autopick'>[MULE.auto_pickup ? "(<B>On</B>)": "(<B>Off</B>)"]</A><BR><BR>" //Hue.

				dat += "\[<A href='byond://?src=\ref[src];mule=stop'>Stop</A>\] "
				dat += "\[<A href='byond://?src=\ref[src];mule=go'>Proceed</A>\] "
				dat += "\[<A href='byond://?src=\ref[src];mule=home'>Return Home</A>\]<BR>"

			else
				dat += "<BR>\[<A href='byond://?src=\ref[src];op=patroloff'>Stop Patrol</A>\] "	//patrolon
				dat += "\[<A href='byond://?src=\ref[src];op=patrolon'>Start Patrol</A>\] "	//patroloff
				dat += "\[<A href='byond://?src=\ref[src];op=summon'>Summon Bot</A>\]<BR>"		//summon
				dat += "Keep an ID inserted to upload access codes upon summoning."

			dat += "<HR><A href='byond://?src=\ref[src];op=botlist'><img src=pda_back.png>Return to bot list</A>"
		else
			dat += "<BR><A href='byond://?src=\ref[src];op=botlist'><img src=pda_refresh.png>Scan for active bots</A><BR><BR>"
			var/turf/current_turf = get_turf(src)
			var/zlevel = current_turf.z
			var/botcount = 0
			for(Bot in living_mob_list) //Git da botz
				if(!Bot.on || Bot.z != zlevel || Bot.remote_disabled || !(tablet.bot_access_flags & Bot.bot_type)) //Only non-emagged bots on the same Z-level are detected!
					continue //Also, the PDA must have access to the bot type.
				dat += "<A href='byond://?src=\ref[src];op=control;bot=\ref[Bot]'><b>[Bot.name]</b> ([Bot.get_mode()])<BR>"
				botcount++
			if(!botcount) //No bots at all? Lame.
				dat += "No bots found.<BR>"

	Topic(href, href_list)
		if (!..()) return
		//Bot control section! Viciously ripped from radios for being laggy and terrible.
		if(href_list["op"])
			switch(href_list["op"])

				if("control")
					active_bot = locate(href_list["bot"])

				if("botlist")
					active_bot = null
				if("summon") //Args are in the correct order, they are stated here just as an easy reminder.
					active_bot.bot_control(command= "summon", user_turf= get_turf(usr), user_access= tablet.GetAccess())
				else //Forward all other bot commands to the bot itself!
					active_bot.bot_control(command= href_list["op"], user= usr)

		if(href_list["mule"]) //MULEbots are special snowflakes, and need different args due to how they work.

			active_bot.bot_control(command= href_list["mule"], user= usr, pda= 1)

		tablet.attack_self()