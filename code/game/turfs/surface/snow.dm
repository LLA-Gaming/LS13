// Global for easy access

var/global/list/Z1_SURFACE_TURFS = list()
var/global/list/Z1_SNOW_TURFS = list()

/turf/open/surface
	icon = 'icons/turf/snow.dmi'
	name = "surface"
	icon_state = "snow1"
	intact = 0

	heat_capacity = 700000

	var/global/datum/gas_mixture/planet/planet_gas = new

	proc/update_icon()
		return

	New()
		..()

		if(z == ZLEVEL_STATION)
			Z1_SURFACE_TURFS += src

/*
* Snow
*/

/turf/open/surface/snow/

	New()
		..()

		if(z == ZLEVEL_STATION)
			Z1_SNOW_TURFS += src

	var/depth = 1

	update_icon()
		icon_state = "snow[depth]"
		cut_overlays()
		if(prob(20))
			var/image/overlay = image(icon = icon, icon_state = "debris[rand(0, 12)]")
			overlay.plane = src.plane
			add_overlay(overlay)

	examine()
		..()

		switch(depth)
			if(1 to 2)
				usr << "This snow looks shallow."
			if(3 to 4)
				usr << "This snow looks to be about knee-height."
			if(5 to 6)
				usr << "This snow looks to be about waist-height."
			if(7 to 8)
				usr << "This snow looks to be about human-height."

	proc/SetDepth(var/new_depth)
		depth = Clamp(new_depth, 1, 8)
		update_icon()