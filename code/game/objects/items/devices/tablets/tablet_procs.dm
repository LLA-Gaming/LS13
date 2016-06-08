//
// Update the label
//
/obj/item/device/tablet/proc/update_label()
	name = "[device_type]-[core.owner] ([core.ownjob])" //Name generalisation
	owner = core.owner
	ownjob = core.ownjob

//
// Add new program
//
/obj/item/device/tablet/proc/add_program(var/prog_type)
	if(!core)
		return
	if(locate(prog_type) in core.programs)
		return

	var/datum/program/new_program = new prog_type

	core.programs.Add(new_program)
	return new_program

//
// ID check
//
/obj/item/device/tablet/proc/id_check(mob/user, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			remove_id()
		else
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id))
				if(!user.unEquip(I))
					return 0
				I.loc = src
				id = I
	else
		var/obj/item/weapon/card/I = user.get_active_hand()
		if (istype(I, /obj/item/weapon/card/id) && I:registered_name)
			if(!user.unEquip(I))
				return 0
			var/obj/old_id = id
			I.loc = src
			id = I
			user.put_in_hands(old_id)
	return 1

/obj/item/device/tablet/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/device/tablet/GetID()
	return id
//
// ID remove
//
/obj/item/device/tablet/proc/remove_id()
	if (id)
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			usr << "<span class='notice'>You remove the ID from the [name].</span>"
		else
			id.loc = get_turf(src)
		id = null

//
// proc to check if the tablet can connect to the network
//
/obj/item/device/tablet/proc/tablet2network()
	var/obj/machinery/message_server/useMS = null
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			if(MS.active)
				useMS = MS
				break

	var/datum/signal/signal = src.telecomms_process()

	if(signal)
		return useMS
	else
		return 0

//
// proc to check if the tablet can connect to another tablet
//
/obj/item/device/tablet/proc/tablet2tablet(obj/item/device/tablet/P)
	if(!P || qdeleted(P) || !P.messengeron)
		return null

	var/obj/machinery/message_server/useMS = null
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			if(MS.active)
				useMS = MS
				break

	var/datum/signal/signal = src.telecomms_process()

	if(!P || qdeleted(P) || !P.messengeron) //in case the PDA or mob gets destroyed during telecomms_process()
		return 0

	var/useTC = 0
	if(signal)
		if(signal.data["done"])
			useTC = 1
			var/turf/pos = get_turf(P)
			if(pos.z in signal.data["level"])
				useTC = 2

	if(useTC == 2)
		return useMS
	else
		return 0

// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/obj/item/device/tablet/emp_act(severity)
	for(var/atom/A in src)
		A.emp_act(severity)
	emped += 1
	spawn(200 * severity)
		emped -= 1

/obj/item/device/tablet/proc/alert_self(var/alert,var/details,var/app_type)
	if(!core) return
	var/datum/program/program = null
	if(app_type)
		for(var/datum/program/P in core.programs)
			if(P.type == app_type)
				if(P.alertsoff)
					return
				program = P
	if(!tablet2network())
		return
	var/mob/living/L = null
	if(src.loc && isliving(src.loc))
		L = src.loc
	if(!silent)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(3, loc))
			O.show_message(text("\icon[src] *[core.ttone]*"))
	if(istype(src,/obj/item/device/tablet/laptop))
		for (var/mob/O in hearers(1, loc))
			O.show_message(text("\icon[src] <b>[alert]</b> - [details]"))
	if(L)
		L << "\icon[src] <b>[alert]</b> - [details]"
	if(program && core)
		program.notifications++
	check_alerts()

/obj/item/device/tablet/proc/check_alerts()
	overlays.Cut()
	var/N = 0
	if(core)
		for(var/datum/program/P in core.programs)
			if(!P.notifications)
				continue
			N = 1
		if(N)
			if(istype(src,/obj/item/device/tablet/laptop))
				if(mounted)
					overlays.Cut()
					overlays += image('icons/obj/Laptop.dmi', "Laptop_open_r")
				if(!mounted)
					overlays.Cut()
					overlays += image('icons/obj/Laptop.dmi', "Laptop_closed_r")
				return
			if(istype(src,/obj/item/device/tablet/))
				overlays.Cut()
				overlays += image('icons/obj/tablets.dmi', "tablet-r")
				return
			else
				return

/obj/item/device/tablet/proc/explode() //This needs tuning.
	if(!candetonate) return
	var/turf/T = get_turf(src)

	if (ismob(loc))
		var/mob/M = loc
		M.show_message("<span class='userdanger'>Your [src] explodes!</span>", 1)
	else
		visible_message("<span class='danger'>[src] explodes!</span>", "<span class='warning'>You hear a loud *pop*!</span>")

	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 2, 3)
	qdel(src)
	return

//
// Shortcuts
//
/obj/item/device/tablet/AltClick()
	if(issilicon(usr))
		..()
		return

	if(usr.canUseTopic(src))
		if(id)
			verb_remove_id()
		else if(pen)
			verb_remove_pen()
		else
			..()
	else
		..()


/obj/item/device/tablet/verb/verb_remove_id()
	set category = "Object"
	set name = "Eject ID"
	set src in usr

	if(issilicon(usr))
		return

	if (usr.canUseTopic(src))
		if(id)
			remove_id()
		else
			usr << "<span class='warning'>This Tablet does not have an ID in it!</span>"

/obj/item/device/tablet/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove Pen"
	set src in usr

	if(issilicon(usr))
		return

	if (usr.canUseTopic(src))
		var/obj/item/weapon/pen/O = locate() in src
		if(O)
			if (istype(loc, /mob))
				var/mob/M = loc
				if(M.get_active_hand() == null)
					M.put_in_hands(O)
					usr << "<span class='notice'>You remove \the [O] from \the [src].</span>"
					return
			O.loc = get_turf(src)
		else
			usr << "<span class='warning'>This tablet does not have a pen in it!</span>"



//
// Toggle mounts (laptop only)
//
/obj/item/device/tablet/proc/toggle_mount()
	return

/obj/item/device/tablet/laptop/toggle_mount()
	if(loc == usr) return
	if(mounted)
		mounted = 0
		icon_state = "Laptop_closed"
	else
		mounted = 1
		icon_state = "Laptop_open"
	check_alerts()

//
// MouseDrop (tablet only)
//
/obj/item/device/tablet/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && M.canUseTopic(src))
		return attack_self(M)
	return

//
// MouseDrop (laptop only)
//
/obj/item/device/tablet/laptop/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if(M.canUseTopic(src))
		return toggle_mount()
	return

//
// Toggle Laptop (laptop only)
//
/obj/item/device/tablet/laptop/verb/toggle_laptop()
	set name = "Toggle Laptop"
	set category = "Object"
	set src in oview(1)

	if(!usr.canUseTopic(src))
		return

	toggle_mount()
	add_fingerprint(usr)

//
// Interact with laptop (laptop only)
//
/obj/item/device/tablet/laptop/attack_hand(mob/living/user)
	if(!mounted && !bolted)
		..()
	if(bolted && !mounted)
		usr << "It's bolted to the ground!"
	if(mounted)
		return
		//tablet_interact(usr)

/obj/item/device/tablet/laptop/pickup()
	if(mounted && !bolted)
		toggle_mount()
		..()
	if(bolted)
		usr << "It's bolted to the ground!"

/obj/item/device/tablet/laptop/attack_self(mob/living/user)
	if(loc == user) return
	..()

/obj/item/device/tablet/laptop/Topic(href, href_list)
	if(!mounted)
		return
	..()

//
// Get tablets
//
/proc/get_viewable_tablets()
	. = list()
	// Returns a list of PDAs which can be viewed from another PDA/message monitor.
	for(var/obj/item/device/tablet/T in all_tablets)
		if(!T.owner || !T.core || T.hidden) continue
		. += T
	return .