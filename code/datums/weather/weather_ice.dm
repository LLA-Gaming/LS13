/datum/weather/planet
	name = "unnamed storm"
	desc = "This is not a real storm"
	area_type = /area/surface
	target_zs = list(1,3,4,6) //all planet Zs
	probability = 0
	telegraph_outdoors_only = 1

/datum/weather/planet/rain
	name = "rain"
	desc = "light rain shower"

	telegraph_message = "<span class='boldwarning'>You feel a bit of a drizzle coming from the sky</span>"
	telegraph_duration = 300

	weather_message = "<span class='userdanger'><i>The clouds darken and it begins to rain</i></span>"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_overlay = "rain"

	end_message = "<span class='boldannounce'>The clouds seperate and the rain seems to end..</span>"
	end_duration = 300

	immunity_type = "rain"
	probability = 10

	impact(mob/living/L)
		return

/datum/weather/planet/hail
	name = "hail"
	desc = "heavy hail shower"

	telegraph_message = "<span class='boldwarning'>You feel a bit of a drizzle coming from the sky</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_hail"

	weather_message = "<span class='userdanger'><i>The clouds darken and it begins to hail</i></span>"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_overlay = "hail"

	end_message = "<span class='boldannounce'>The clouds seperate and the hail seems to end..</span>"
	end_duration = 300
	telegraph_overlay = "light_hail"

	immunity_type = "hail"
	probability = 10

	impact(mob/living/L)
		if(istype(L.loc, /obj/mecha))
			return
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/thermal_protection = H.get_thermal_protection()
			if(thermal_protection <= SPACE_SUIT_MIN_TEMP_PROTECT)
				return
		L.adjustBruteLoss(4)

/datum/weather/planet/snow
	name = "snow storm"
	desc = "heavy snow storm"

	telegraph_message = "<span class='boldwarning'>You feel a bit of a snowflakes coming from the sky</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snowstorm"

	weather_message = "<span class='userdanger'><i>The clouds darken and it begins to snow</i></span>"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_overlay = "snowstorm"

	end_message = "<span class='boldannounce'>The clouds seperate and the snow seems to end..</span>"
	end_duration = 300
	telegraph_overlay = "light_snowstorm"

	immunity_type = "snow"
	probability = 15

	impact(mob/living/L)
		if(istype(L.loc, /obj/mecha))
			return
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/thermal_protection = H.get_thermal_protection()
			if(thermal_protection <= SPACE_SUIT_MIN_TEMP_PROTECT)
				return
		L.adjustFireLoss(4)

/datum/weather/planet/radiation
	name = "radiation storm"
	desc = "radiation storm"

	telegraph_message = "<span class='boldwarning'>You feel a bit warm</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_rads"

	weather_message = "<span class='userdanger'><i>The sky turns a errie yellow. The ground starts to radiate</i></span>"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_overlay = "rads"

	end_message = "<span class='boldannounce'>The last of the radiation dissipates. It is safe go outside.</span>"
	end_duration = 300
	end_overlay = "light_rads"

	immunity_type = "radiation"
	probability = 3

	impact(mob/living/L)
		L.rad_act(rand(0,3))