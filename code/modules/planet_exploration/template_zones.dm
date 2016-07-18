//Template Zones!!
//Requires a 255x255 empty map
//the following defines fit a 255x255 map with 17x17 zones 15 size each. change if the map every changes size
#define ZONE_MASTER_X_MAX	17
#define ZONE_MASTER_Y_MAX 	17
#define ZONE_MASTER_X_MIN	1
#define ZONE_MASTER_Y_MIN 	1
#define ZONE_SIZE		 	15

/datum/template_zone_master
	var/z_level
	var/list/zones[ZONE_MASTER_X_MAX][ZONE_MASTER_Y_MAX] //Zones by coordinate
	var/list/all_zones = list() //All zones in this Z
	var/budget = 2

	proc/fill_template_zones()
		for(var/V in shuffle(all_zones))
			var/datum/template_zone/zone = V
			if(zone.edge)
				continue
			if(zone.current_template)
				continue
			zone.spawn_template()

	proc/random_zone(var/size_budget_min = 1)
		var/datum/template_zone/zone

		for(var/V in shuffle(all_zones))
			zone = V
			if(zone.can_fit(size_budget_min))
				break

		return zone



/datum/template_zone
	var/xi //where they exist on the zone master map
	var/yi //where they exist on the zone master map
	var/obj/effect/landmark/planet_marker/template_corner/bottomleft
	var/obj/effect/landmark/planet_marker/template_corner/bottomright
	var/obj/effect/landmark/planet_marker/template_corner/topleft
	var/obj/effect/landmark/planet_marker/template_corner/topright
	var/datum/map_template/planet/current_template
	var/datum/template_zone_master/master
	var/edge = 0 //this zone sits on the edge of a z-level, templates cannot spawn here
	var/list/linked = list()
	var/permanent = 0
	var/max_size = 0

	proc/spawn_template(var/datum/map_template/planet/template)
		var/list/templates = SSmapping.planet_templates

		if(!template)
			template = random_template(templates,master.budget)

		if(template)
			bottomleft.load_template(template, src)

	proc/random_template(var/list/all_templates,var/budget)
		var/list/possible = list()
		var/list/budgeted_possible = list()
		var/datum/map_template/planet/picked

		for(var/V in all_templates)
			var/datum/map_template/planet/P = V
			if(!can_fit(P.size))
				continue
			if(P.max_active >= 0 && P.loaded >= P.max_active)
				continue
			if(P.budget && P.budget > budget)
				continue
			possible += P
			if(P.budget)
				budgeted_possible += P

		if(!possible.len)
			return

		//considered budgeted templates before normal templates
		if(budgeted_possible.len)
			picked = pick(budgeted_possible)
		else
			picked = pick(possible)

		return picked

	proc/can_fit(var/size_arg)
		if(max_size < size_arg)
			return 0
		var/list/zones = list()
		for(var/i1 = yi, i1 < yi + size_arg, i1++)
			for(var/i2 = xi, i2 < xi + size_arg, i2++)
				var/datum/template_zone/next_zone = master.zones[i2][i1]
				if(next_zone == src)
					continue
				zones += next_zone
		for(var/V in zones)
			var/datum/template_zone/zone = V
			if(zone.current_template)
				return 0
		return 1


/proc/setup_template_zones(var/z_level)
	var/datum/template_zone_master/zone_master = new
	zone_master.z_level = z_level

	for(var/yi=ZONE_MASTER_Y_MIN , yi<= ZONE_MASTER_X_MAX, yi++)
		for(var/xi=ZONE_MASTER_X_MIN , xi<= ZONE_MASTER_X_MAX, xi++)
			var/datum/template_zone/zone = create_template_zone(xi, yi, z_level)
			zone_master.all_zones.Add(zone)
			zone_master.zones[zone.xi][zone.yi] = zone
			zone.master = zone_master

	zone_master.fill_template_zones()

	return zone_master


/proc/create_template_zone(var/xi, var/yi, var/z_level)
	var/datum/template_zone/zone = new
	if(xi == ZONE_MASTER_X_MIN || yi == ZONE_MASTER_Y_MAX || xi == ZONE_MASTER_X_MAX || yi == ZONE_MASTER_Y_MIN)
		zone.edge = 1

	zone.xi = xi
	zone.yi = yi
	var/topright_x = xi * ZONE_SIZE
	var/topright_y = yi * ZONE_SIZE
	var/bottomleft_x = (xi * ZONE_SIZE) - (ZONE_SIZE - 1)
	var/bottomleft_y = (yi * ZONE_SIZE) - (ZONE_SIZE - 1)
	var/topleft_x = (xi * ZONE_SIZE) - (ZONE_SIZE - 1)
	var/topleft_y = yi * ZONE_SIZE
	var/bottomright_x = xi * ZONE_SIZE
	var/bottomright_y = (xi * ZONE_SIZE) - (ZONE_SIZE - 1)
	var/max_size_x = (ZONE_MASTER_X_MAX) - xi
	var/max_size_y = (ZONE_MASTER_Y_MAX) - yi

	zone.max_size = min(max_size_x,max_size_y)

	zone.bottomleft = new /obj/effect/landmark/planet_marker/template_corner(locate(bottomleft_x,bottomleft_y,z_level))
	zone.bottomright = new /obj/effect/landmark/planet_marker/template_corner(locate(bottomright_x,bottomright_y,z_level))
	zone.topleft = new /obj/effect/landmark/planet_marker/template_corner(locate(topleft_x,topleft_y,z_level))
	zone.topright = new /obj/effect/landmark/planet_marker/template_corner(locate(topright_x,topright_y,z_level))

	return zone



/obj/effect/landmark/planet_marker/
	name = "Planet Marker"

/obj/effect/landmark/planet_marker/template_corner
	name = "Template Corner"

	New()
		name = "Template Corner*[x],[y],[z]"
		..()

	proc/load_template(var/datum/map_template/planet/template, var/datum/template_zone/zone)
		zone.current_template = template
		zone.linked += zone
		if(template.size != 1)

			for(var/yi = zone.yi, yi < zone.yi + template.size, yi++)
				for(var/xi = zone.xi, xi < zone.xi + template.size, xi++)
					var/datum/template_zone/next_zone = zone.master.zones[xi][yi]
					if(next_zone == zone)
						continue
					zone.linked += next_zone
					next_zone.current_template = template

			for(var/V in zone.linked)
				var/datum/template_zone/linked_zones = V
				linked_zones.linked = zone.linked.Copy()

		template.load(get_turf(src), log = FALSE) //would be spammy otherwise
		template.active_count++
		zone.master.budget -= template.budget

#undef ZONE_MASTER_X_MAX
#undef ZONE_MASTER_Y_MAX
#undef ZONE_MASTER_X_MIN
#undef ZONE_MASTER_Y_MIN
#undef ZONE_SIZE