var/datum/subsystem/daynight/SSdaynight

/datum/subsystem/daynight
	name = "Daynight"
	init_order = 4
	display_order = 4
	wait = 500 //50 seconds per hour, 24 hours. 20 minute full day cycle. 3 day round average.
	priority = 100
	flags = SS_KEEP_TIMING|SS_NO_INIT
	var/area_type = /area/surface
	var/day_count = 1 //How many days it has been, starting at 1
	var/is_night = 0 //If it is currently night time
	var/current_time = 1
	var/current_name
	var/current_alpha
	var/current_color
	var/list/times_of_day = list(
		list("name" = "6 AM",     "alpha" = 255),
		list("name" = "7 AM",     "alpha" = 255),
		list("name" = "8 AM",     "alpha" = 255),
		list("name" = "9 AM",     "alpha" = 255),
		list("name" = "10 AM",    "alpha" = 255),
		list("name" = "11 AM",    "alpha" = 255),
		list("name" = "NOON",     "alpha" = 255),
		list("name" = "1 PM",     "alpha" = 255),
		list("name" = "2 PM",     "alpha" = 255),
		list("name" = "3 PM",     "alpha" = 255),
		list("name" = "4 PM",     "alpha" = 255),
		list("name" = "5 PM",     "alpha" = 230),
		list("name" = "6 PM",     "alpha" = 205),
		list("name" = "7 PM",     "alpha" = 120),
		list("name" = "8 PM",     "alpha" = 55),
		list("name" = "9 PM",     "alpha" = 0),
		list("name" = "10 PM",    "alpha" = 0),
		list("name" = "11 PM",    "alpha" = 0),
		list("name" = "MIDNIGHT", "alpha" = 0),
		list("name" = "1 AM",     "alpha" = 0),
		list("name" = "2 AM",     "alpha" = 0),
		list("name" = "3 AM",     "alpha" = 55),
		list("name" = "4 AM",     "alpha" = 120),
		list("name" = "5 AM",     "alpha" = 205))

/datum/subsystem/daynight/New()
	NEW_SS_GLOBAL(SSdaynight)
	var/list/timedata = times_of_day[1]
	current_name = timedata["name"]
	current_alpha = timedata["alpha"]

/datum/subsystem/daynight/stat_entry()
	..("[is_night ? "Night" : "Day"]: [day_count] | Time:[current_name]")


/datum/subsystem/daynight/fire()
	nexthour()

/datum/subsystem/daynight/proc/announce_day()
	return
/datum/subsystem/daynight/proc/announce_night()
	return

/datum/subsystem/daynight/proc/nexthour()
	current_time++
	if(current_time > times_of_day.len)
		current_time = 1
	var/list/timedata = times_of_day[current_time]
	current_name = timedata["name"]
	current_alpha = timedata["alpha"]
	if(current_name == "6 PM")
		is_night = 1
		announce_night()
	if(current_name == "6 AM")
		day_count++
		is_night = 0
		announce_day()
	for(var/V in get_areas(area_type))
		var/area/A = V
		A.updateicon()

//Time reversal?
/datum/subsystem/daynight/proc/lasthour()
	current_time--
	if(current_time < 0)
		current_time = times_of_day.len
	var/list/timedata = times_of_day[current_time]
	current_name = timedata["name"]
	current_alpha = timedata["alpha"]
	if(current_name == "5 AM")
		day_count--
		if(day_count <= 0)
			day_count = 1
		is_night = 1
		announce_night()
	if(current_name == "5 PM")
		is_night = 0
		announce_day()
	for(var/V in get_areas(area_type))
		var/area/A = V
		A.updateicon()