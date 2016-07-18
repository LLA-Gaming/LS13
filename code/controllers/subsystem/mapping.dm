var/datum/subsystem/mapping/SSmapping

/datum/subsystem/mapping
	name = "Mapping"
	init_order = -5
	flags = SS_NO_FIRE
	display_order = 50
	var/list/z_levels = list()
	var/list/template_zone_masters = list()
	var/list/planet_templates = list()


/datum/subsystem/mapping/New()
	NEW_SS_GLOBAL(SSmapping)
	return ..()


/datum/subsystem/mapping/Initialize(timeofday)
	preloadTemplates()
	// Pick a random away mission.
	createRandomZlevel()

	// Generate mining.
	/*
	var/mining_type = MINETYPE
	if (mining_type == "lavaland")
		seedRuins(5, config.lavaland_budget, /area/lavaland/surface/outdoors, lava_ruins_templates)
		spawn_rivers()
	else
		make_mining_asteroid_secrets()

	// deep space ruins
	seedRuins(7, rand(0,2), /area/space, space_ruins_templates)
	seedRuins(8, rand(0,2), /area/space, space_ruins_templates)
	seedRuins(9, rand(0,2), /area/space, space_ruins_templates)
	*/
	// Set up Z-level transistions.
	setup_map_transitions()

	//Setup the planet template zones on the 3 empty planet Zs (1, 3, and 6)
	for(var/type in typesof(/datum/map_template/planet) - /datum/map_template/planet)
		var/datum/map_template/planet/T = new type()
		planet_templates += T
	template_zone_masters["3"] = setup_template_zones(3)
	template_zone_masters["4"] = setup_template_zones(4)
	template_zone_masters["6"] = setup_template_zones(6)

	..()

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT