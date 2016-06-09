/obj/item/device/tablet/laptop
	name = "Laptop"
	icon = 'icons/obj/Laptop.dmi'
	icon_state = "Laptop_closed"
	w_class = 3
	slot_flags = SLOT_BELT

	default_programs = list(/datum/program/notekeeper)

	size_w = 640
	size_h = 480
	laptop = 1

	New()
		..()
		//core.programs.Add(new /datum/program/nanonet)

	update_label()
		name = "Laptop-[core.owner] ([core.ownjob])" //Name generalisation
		owner = core.owner
		ownjob = core.ownjob

	attackby(obj/item/C as obj, mob/user as mob)
		..()
		if(istype(C, /obj/item/weapon/screwdriver))
			if(loc == usr) return
			if(bolted)
				bolted = 0
				anchored = 0
				playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
				user << "<span class='notice'>You unbolt [src] from the ground</span>"
			else
				bolted = 1
				anchored = 1
				playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
				user << "<span class='notice'>You bolt [src] to the ground</span>"
		if(core)
			if(istype(C, /obj/item/weapon/paper))
				var/obj/item/weapon/paper/A = C
				var/exists = 0
				for(var/datum/tablet_data/document/D in core.files)
					if(D.doc == A.info)
						exists = 1
						break
				if(exists)
					user << "\blue Document already exists, aborting scan."
				else
					var/datum/tablet_data/document/doc = new /datum/tablet_data/document/
					doc.fields = A:fields
					doc.doc = A.info
					doc.doc_links = A.info_links
					doc.name = A:name
					user << "\blue Paper scanned."
					core.files.Add(doc)
			if(istype(C, /obj/item/weapon/photo))
				var/obj/item/weapon/photo/A = C
				var/exists = 0
				for(var/datum/tablet_data/photo/D in core.files)
					if(D.photoinfo == A:img)
						exists = 1
						break
				if(exists)
					user << "\blue Photo already exists, aborting scan."
				else
					var/datum/tablet_data/photo/pic = new /datum/tablet_data/photo/
					pic.photoinfo = A.img
					user << "\blue Photo scanned."
					core.files.Add(pic)

	proc/toggle_mount()
		if(loc == usr) return
		if(mounted)
			mounted = 0
			icon_state = "Laptop_closed"
		else
			mounted = 1
			icon_state = "Laptop_open"
		check_alerts()

	MouseDrop(obj/over_object as obj, src_location, over_location)
		var/mob/M = usr
		if(can_use(M) && src in oview(1))
			return toggle_mount()
		return

	verb/toggle_laptop()
		set name = "Toggle Laptop"
		set category = "Object"
		set src in oview(1)

		//ghost interaction check
		if(istype(usr,/mob/dead/observer) && config && !config.ghost_interaction)
			return

		toggle_mount()
		add_fingerprint(usr)

	attack_hand(mob/living/user)
		if(!mounted && !bolted)
			..()
		if(bolted && !mounted)
			usr << "It's bolted to the ground!"
		if(mounted)
			attack_self(usr)

	verb_pickup()
		if(mounted && !bolted)
			toggle_mount()
			..()
		if(bolted)
			usr << "It's bolted to the ground!"

	attack_self(mob/living/user)
		if(loc == user) return
		..()

	Topic(href, href_list)
		var/mob/U = usr
		if(!mounted)
			popup.close()
			U.unset_machine()
			return
		..()

//Laptop flavors//

/obj/item/device/tablet/laptop/cargo
	name = "Cargo Laptop"
	can_eject = 0
	anchored = 1
	messengeron = 0

/obj/item/device/tablet/laptop/security
	name = "Security Laptop"
	can_eject = 0
	anchored = 1
	messengeron = 0

/obj/item/device/tablet/laptop/engineering
	name = "Engineering Laptop"
	can_eject = 0
	anchored = 1
	messengeron = 0

/obj/item/device/tablet/laptop/medical
	name = "Medical Laptop"
	can_eject = 0
	anchored = 1
	messengeron = 0

/obj/item/device/tablet/laptop/research
	name = "Research Laptop"
	can_eject = 0
	anchored = 1
	messengeron = 0

/obj/item/device/tablet/laptop/public
	name = "Public Laptop"
	can_eject = 0
	anchored = 1
	messengeron = 0

/obj/item/device/tablet/laptop/prison
	name = "Prison Laptop"
	can_eject = 0
	banned = 1

/obj/item/device/tablet/laptop/perseus
	name = "Perseus Laptop"
	can_eject = 0
	messengeron = 0
