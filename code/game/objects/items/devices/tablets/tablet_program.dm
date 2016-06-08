/datum/program
	var/name = "Program Name"
	var/obj/item/device/tablet/tablet
	var/obj/machinery/message_server/network
	var/alertsoff = 0
	var/app_id
	var/toggleon
	var/price = 0

	//settings
	var/alerts = 1 //are alerts enabled on the program
	var/usesalerts = 0
	var/drm = 0
	var/notifications = 0 // shows a [1] when there is a new notification on the application.

/datum/program/builtin

/datum/program/toggles/
/datum/program/toggles/camera
/datum/program/atmosscan

//Change these procs
/datum/program/proc/ViewApp()
	return

/datum/program/proc/CommandApp(href, href_list)
	return

//don't change these procs
/datum/program/proc/app(var/obj/item/device/tablet/T)
	if(!T)
		return
	tablet = T
	network = tablet.tablet2network()
	notifications = 0
	return ViewApp()

/datum/program/Topic(href, href_list)
	..()
	network = tablet.tablet2network()
	if(usr.canUseTopic(tablet) && !href_list["close"])
		CommandApp(href, href_list)