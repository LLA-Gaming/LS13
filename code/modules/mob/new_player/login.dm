/mob/new_player/Login()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	if(join_motd)
		src.text2tab("<div class=\"motd\">[join_motd]</div>","ooc")

	if(admin_notice)
		src.text2tab("<span class='notice'><b>Admin Notice:</b>\n \t [admin_notice]</span>","ooc")

	if(config.soft_popcap && living_player_count() >= config.soft_popcap)
		src.text2tab("<span class='notice'><b>Server Notice:</b>\n \t [config.soft_popcap_message]</span>","ooc")

	sight |= SEE_TURFS

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/
	new_player_panel()

	spawn(40)
		if(client)
			client.playtitlemusic()
