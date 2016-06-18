//Ash storms

/datum/weather/ash_storm
	name = "ash storm"
	start_up_time = 300 //30 seconds
	start_up_message = "An eerie moan rises on the wind. Sheets of burning ash blacken the horizon. Seek shelter."
	start_up_sound = 'sound/lavaland/ash_storm_windup.ogg'
	duration_lower = 60 //1 minute
	duration_upper = 150 //2.5 minutes
	duration_message = "Smoldering clouds of scorching ash billow down around you! Get inside!"
	duration_sound = 'sound/lavaland/ash_storm_start.ogg'
	wind_down = 300 // 30 seconds
	wind_down_message = "The shrieking wind whips away the last of the ash and falls to its usual murmur. It should be safe to go outside now."
	wind_down_sound = 'sound/lavaland/ash_storm_end.ogg'

	target_z = ZLEVEL_LAVALAND
	area_type = /area/lavaland/surface/outdoors

	start_up_overlay = "light_ash"
	duration_overlay = "ash_storm"
	overlay_layer = AREA_LAYER

	immunity_type = "ash"


/datum/weather/ash_storm/false_alarm //No storm, just light ember fall
	purely_aesthetic = TRUE
	duration_overlay = "light_ash"
	duration_message = "<span class='notice'>Gentle ashfall surrounds you like grotesque snow. The storm seems to have passed you by.</span>"
	wind_down_message = "The ashfall quietly slows, then stops. Another layer of hardened soot to the volcanic rock beneath you."

/datum/weather/ash_storm/storm_act(mob/living/L)
	if(immunity_type in L.weather_immunities)
		return

	if(istype(L.loc, /obj/mecha))
		return
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/thermal_protection = H.get_thermal_protection()
		if(thermal_protection >= FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT)
			return
	L.adjustFireLoss(4)
