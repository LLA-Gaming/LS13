//Snow

/turf/open/floor/plating/asteroid/snow
	name = "snow"
	desc = "Looks cold."
	icon = 'icons/turf/snow.dmi'
	baseturf = /turf/open/floor/plating/asteroid/snow/dug
	icon_state = "snow"
	icon_plating = "snow"
	initial_gas_mix = "o2=22;n2=82;TEMP=180"
	slowdown = 2
	environment_type = "snow"
	sand_type = /obj/item/stack/sheet/mineral/snow

/turf/open/floor/plating/asteroid/snow/surface
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/snow/dug
	New()
		..()
		dug = 1
		icon_plating = "snow_dug"
		icon_state = "snow_dug"
		slowdown = 0

//Ice
/turf/open/floor/plating/ice
	name = "ice sheet"
	desc = "A sheet of solid ice. Looks slippery."
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"
	temperature = 180
	baseturf = /turf/open/floor/plating/ice
	slowdown = 1
	wet = TURF_WET_PERMAFROST

/turf/open/floor/plating/ice/colder
	temperature = 140

/turf/open/floor/plating/ice/temperate
	temperature = 255.37

/turf/open/floor/plating/ice/break_tile()
	return

/turf/open/floor/plating/ice/burn_tile()
	return

//Plating

/turf/open/floor/plating/snowed
	name = "snowed-over plating"
	desc = "A section of plating covered in a light layer of snow."
	icon = 'icons/turf/snow.dmi'
	icon_state = "snowplating"
	temperature = 180

/turf/open/floor/plating/snowed/colder
	temperature = 140

/turf/open/floor/plating/snowed/temperatre
	temperature = 255.37

//Surface specific
/turf/open/floor/plating/asteroid/snow/surface/proc/update_starlight()
	if(config.starlight)
		for(var/t in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
			if(istype(t, /turf/open/floor/plating/asteroid/snow/surface))
				//let's NOT update this that much pls
				continue
			SetLuminosity(4,1)
			return
		SetLuminosity(0)