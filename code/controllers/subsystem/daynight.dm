var/datum/subsystem/daynight/SSdaynight

/datum/subsystem/daynight
	name = "Daynight"
	init_order = 4
	display_order = 4
	wait = 500 //50 seconds per hour, 24 hours. 20 minute full day cycle. 3 day round average.
	priority = 100
	flags = SS_KEEP_TIMING|SS_NO_INIT
	var/day_count = 1 //How many days it has been, starting at 1
	var/is_night = 0 //If it is currently night time
	var/current_time = 1
	var/current_name
	var/current_alpha
	var/current_color
	var/list/times_of_day = list(
		list("name" = "6 AM",     "alpha" = 125, "color" = "#9999FF"),
		list("name" = "7 AM",     "alpha" = 185, "color" = "#9999FF"),
		list("name" = "8 AM",     "alpha" = 210, "color" = "#FFFFFF"),
		list("name" = "9 AM",     "alpha" = 220, "color" = "#FFFFFF"),
		list("name" = "10 AM",    "alpha" = 225, "color" = "#FFFFFF"),
		list("name" = "11 AM",    "alpha" = 240, "color" = "#FFFFFF"),
		list("name" = "NOON",     "alpha" = 250, "color" = "#FFFFFF"),
		list("name" = "1 PM",     "alpha" = 250, "color" = "#FFFFFF"),
		list("name" = "2 PM",     "alpha" = 250, "color" = "#FFFFFF"),
		list("name" = "3 PM",     "alpha" = 250, "color" = "#FFFFFF"),
		list("name" = "4 PM",     "alpha" = 250, "color" = "#FFFFFF"),
		list("name" = "5 PM",     "alpha" = 250, "color" = "#FF9900"),
		list("name" = "6 PM",     "alpha" = 225, "color" = "#FF9900"),
		list("name" = "7 PM",     "alpha" = 180, "color" = "#FF9900"),
		list("name" = "8 PM",     "alpha" = 75, "color" = "#9999FF"),
		list("name" = "9 PM",     "alpha" = 50, "color" = "#9999FF"),
		list("name" = "10 PM",    "alpha" = 20, "color" = "#9999FF"),
		list("name" = "11 PM",    "alpha" = 1, "color" = "#9999FF"),
		list("name" = "MIDNIGHT", "alpha" = 0, "color" = "#9999FF"),
		list("name" = "1 AM",     "alpha" = 1, "color" = "#9999FF"),
		list("name" = "2 AM",     "alpha" = 5, "color" = "#9999FF"),
		list("name" = "3 AM",     "alpha" = 50, "color" = "#9999FF"),
		list("name" = "4 AM",     "alpha" = 75, "color" = "#9999FF"),
		list("name" = "5 AM",     "alpha" = 100, "color" = "#9999FF"))

/datum/subsystem/daynight/New()
	NEW_SS_GLOBAL(SSdaynight)
	var/list/timedata = times_of_day[1]
	current_name = timedata["name"]
	current_alpha = timedata["alpha"]
	current_color = timedata["color"]

/datum/subsystem/daynight/stat_entry()
	..("[is_night ? "Night" : "Day"]: [day_count] | Time:[current_name]")


/datum/subsystem/daynight/fire()
	current_time++
	if(current_time > times_of_day.len)
		current_time = 1
	var/list/timedata = times_of_day[current_time]
	current_name = timedata["name"]
	current_alpha = timedata["alpha"]
	current_color = timedata["color"]
	if(current_name == "6 PM")
		is_night = 1
	if(current_name == "6 AM")
		day_count++
		is_night = 0