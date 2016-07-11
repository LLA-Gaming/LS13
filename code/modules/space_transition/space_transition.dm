#define Z_LEVEL_NORTH 		"1"
#define Z_LEVEL_SOUTH 		"2"
#define Z_LEVEL_EAST 		"4"
#define Z_LEVEL_WEST 		"8"

//helper proc for finding if the current Z level is on a planet, used in many places
/proc/IsPlanetZ(var/Z_arg)
	if(Z_arg in list(1,3,4,6))
		return 1


/datum/space_level
	var/name = "Your config settings failed, you need to fix this for the datum space levels to work"
	var/list/neighbors = list()
	var/z_value = 1 //actual z placement
	var/linked = SELFLOOPING

/datum/space_level/New(transition_type)
	linked = transition_type
	if(linked == SELFLOOPING)
		neighbors = list()
		var/list/L = list(Z_LEVEL_NORTH,Z_LEVEL_SOUTH,Z_LEVEL_EAST,Z_LEVEL_WEST)
		for(var/A in L)
			neighbors[A] = src


/proc/setup_map_transitions()
	var/list/planet_z_levels = list()
	var/list/space_z_levels = list()
	var/datum/space_level/D
	var/k = 1
	for(var/A in map_transition_config)
		D = new(map_transition_config[A])
		D.name = A
		D.z_value = k
		if(D.linked == PLANETLINKED)
			planet_z_levels["[D.z_value]"] = D
		else if(D.linked == SPACELINKED)
			space_z_levels["[D.z_value]"] = D
		k++

	SSmapping.z_levels["planet"] = planet_z_levels
	SSmapping.z_levels["space"] = space_z_levels

	for(var/L in SSmapping.z_levels)
		setup_map_grid(SSmapping.z_levels[L])
		setup_turf_transitions(SSmapping.z_levels[L])


/proc/setup_map_grid(var/list/z_levels)
	var/datum/space_level/main_level
	var/list/neighbor_levels = list()

	var/count = 1
	for(var/L in z_levels)
		var/datum/space_level/level = z_levels[L]
		if(count == 1)
			main_level = level
		else
			neighbor_levels.Add(level)
		count++

	var/datum/space_level/northsouth_level = pick_n_take(neighbor_levels)
	var/datum/space_level/eastwest_level = pick_n_take(neighbor_levels)

	pair_z_level(main_level,northsouth_level,Z_LEVEL_NORTH)
	pair_z_level(main_level,northsouth_level,Z_LEVEL_SOUTH)

	pair_z_level(main_level,eastwest_level,Z_LEVEL_EAST)
	pair_z_level(main_level,eastwest_level,Z_LEVEL_WEST)

	if(!neighbor_levels.len) // Just 3 Z levels
		var/list/L = list(Z_LEVEL_NORTH,Z_LEVEL_SOUTH,Z_LEVEL_EAST,Z_LEVEL_WEST)
		for(var/A in L)
			northsouth_level.neighbors[A] = main_level
			eastwest_level.neighbors[A] = main_level

	else //More than 3 z-levels, slightly more complicated. at this time only supports 4 total
		var/datum/space_level/distant_level = pick_n_take(neighbor_levels)

		pair_z_level(distant_level,northsouth_level,Z_LEVEL_EAST)
		pair_z_level(distant_level,northsouth_level,Z_LEVEL_WEST)

		pair_z_level(distant_level,eastwest_level,Z_LEVEL_NORTH)
		pair_z_level(distant_level,eastwest_level,Z_LEVEL_SOUTH)



/proc/pair_z_level(var/datum/space_level/level_a, var/datum/space_level/level_b, var/direction)
	switch(direction)
		if(Z_LEVEL_NORTH)
			level_a.neighbors[Z_LEVEL_NORTH] = level_b
			level_b.neighbors[Z_LEVEL_SOUTH] = level_a
		if(Z_LEVEL_SOUTH)
			level_a.neighbors[Z_LEVEL_SOUTH] = level_b
			level_b.neighbors[Z_LEVEL_NORTH] = level_a
		if(Z_LEVEL_EAST)
			level_a.neighbors[Z_LEVEL_EAST] = level_b
			level_b.neighbors[Z_LEVEL_WEST] = level_a
		if(Z_LEVEL_WEST)
			level_a.neighbors[Z_LEVEL_WEST] = level_b
			level_b.neighbors[Z_LEVEL_EAST] = level_a


/proc/setup_turf_transitions(var/list/z_levels)
	for(var/L in z_levels)
		var/datum/space_level/D = z_levels[L]

		if(D.linked == SELFLOOPING || D.linked == UNAFFECTED)
			continue

		var/transition_edge = TRANSITIONEDGE

		var/zlevelnumber = D.z_value

		if(IsPlanetZ(zlevelnumber))
			transition_edge = PLANET_TRANSITIONEDGE

		var/list/x_pos_beginning = list(1, 1, world.maxx - transition_edge, 1)  //x values of the lowest-leftest turfs of the respective 4 blocks on each side of zlevel
		var/list/y_pos_beginning = list(world.maxy - transition_edge, 1, transition_edge, transition_edge)  //y values respectively
		var/list/x_pos_ending = list(world.maxx, world.maxx, world.maxx, transition_edge)	//x values of the highest-rightest turfs of the respective 4 blocks on each side of zlevel
		var/list/y_pos_ending = list(world.maxy, transition_edge, world.maxy - transition_edge, world.maxy - transition_edge)	//y values respectively
		var/list/x_pos_transition = list(1, 1, transition_edge + 2, world.maxx - transition_edge - 2)		//values of x for the transition from respective blocks on the side of zlevel, 1 is being translated into turfs respective x value later in the code
		var/list/y_pos_transition = list(transition_edge + 2, world.maxy - transition_edge - 2, 1, 1)		//values of y for the transition from respective blocks on the side of zlevel, 1 is being translated into turfs respective y value later in the code

		for(var/side = 1, side<5, side++)
			var/turf/beginning = locate(x_pos_beginning[side], y_pos_beginning[side], zlevelnumber)
			var/turf/ending = locate(x_pos_ending[side], y_pos_ending[side], zlevelnumber)
			var/list/turfblock = block(beginning, ending)
			var/dirside = 2**(side-1)
			var/zdestination = zlevelnumber
			if(D.neighbors["[dirside]"] && D.neighbors["[dirside]"] != D)
				D = D.neighbors["[dirside]"]
				zdestination = D.z_value
			else
				dirside = turn(dirside, 180)
				while(D.neighbors["[dirside]"] && D.neighbors["[dirside]"] != D)
					D = D.neighbors["[dirside]"]
				zdestination = D.z_value
			D = z_levels[L]

			if(IsPlanetZ(zlevelnumber))
				for(var/turf/open/floor/plating/asteroid/snow/surface/S in turfblock)
					S.destination_x = x_pos_transition[side] == 1 ? S.x : x_pos_transition[side]
					S.destination_y = y_pos_transition[side] == 1 ? S.y : y_pos_transition[side]
					S.destination_z = zdestination
			else
				for(var/turf/open/space/S in turfblock)
					S.destination_x = x_pos_transition[side] == 1 ? S.x : x_pos_transition[side]
					S.destination_y = y_pos_transition[side] == 1 ? S.y : y_pos_transition[side]
					S.destination_z = zdestination