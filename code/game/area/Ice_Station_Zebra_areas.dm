/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/area
	level = null
	name = "Space"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREA_LAYER
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING

	var/map_name // Set in New(); preserves the name set by the map maker, even if renamed by the Blueprints.

	var/valid_territory = 1 // If it's a valid territory for gangs to claim
	var/blob_allowed = 1 // Does it count for blobs score? By default, all areas count.

	var/eject = null

	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	var/lightswitch = 1

	var/requires_power = 1
	var/always_unpowered = 0	// This gets overriden to 1 for space in area/New().

	var/outdoors = 0 //For space, the asteroid, lavaland, etc. Used with blueprints to determine if we are adding a new area (vs editing a station room)

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0
	var/static_equip
	var/static_light = 0
	var/static_environ

	var/has_gravity = 0
	var/noteleport = 0			//Are you forbidden from teleporting to the area? (centcomm, mobs, wizard, hand teleporter)
	var/safe = 0 				//Is the area teleport-safe: no space / radiation / aggresive mobs / other dangers

	var/no_air = null
	var/area/master				// master area used for power calcluations
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/proc/process_teleport_locs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/wizard_station) || AR.noteleport) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = safepick(get_area_turfs(AR.type))
		if (picked && (picked.z == ZLEVEL_STATION))
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	sortTim(teleportlocs, /proc/cmp_text_dsc)


//Surface

/area/planet
	name = "Surface"
	icon_state = "space"
	has_gravity = 1
	requires_power = 1
	always_unpowered = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	valid_territory = 0
	blob_allowed = 0 //Eating up the surface doesn't count for victory as a blob.
	ambientsounds = list('sound/ambience/ambimine.ogg')
	music = null

/area/planet/outdoors
	name = "Surface"
	outdoors = 1


//Station areas
/area/station
	name = "Ice Station Zebra"
	has_gravity = 1


//Maintenance
/area/station/maintenance
	ambientsounds = list('sound/ambience/ambimaint1.ogg',
						 'sound/ambience/ambimaint2.ogg',
						 'sound/ambience/ambimaint3.ogg',
						 'sound/ambience/ambimaint4.ogg',
						 'sound/ambience/ambimaint5.ogg',
						 'sound/voice/lowHiss2.ogg', //Xeno Breathing Hisses, Hahahaha I'm not even sorry.
						 'sound/voice/lowHiss3.ogg',
						 'sound/voice/lowHiss4.ogg')
	valid_territory = 0

/area/station/maintenance/dorms
	name = "Dormitory Maintenance"
	icon_state = "fsmaint"

//Civilian
/area/station/dormitories
	name = "Dormitories"
	icon_state = "Sleep"
	safe = 1

/area/station/dormitories/lockerroom
	name = "Locker Room"
	icon_state = "locker"

/area/station/dormitories/toilets
	name = "Restroom"
	icon_state = "toilet"

/area/station/hallway/civilian
	name = "Civilian Hallway"
	icon_state = "construction"

//Misc
/area/station/storage/tools
	name = "Tool Storage"
	icon_state = "storage"