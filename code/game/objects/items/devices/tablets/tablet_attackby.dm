//Splitting attackby procs into seperate procs for maintainability

/obj/item/device/tablet/attackby(obj/item/C, mob/user, params)
	attackby_coreless(C, user, params)
	attackby_laptop(C, user, params)
	attackby_tablet(C, user, params)


/obj/item/device/tablet/proc/attackby_coreless(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/device/tablet_core))
		var/obj/item/device/tablet_core/D = C
		core = D
		if(!user.unEquip(D))
			return
		D.loc = src
		user << "<span class='notice'>You insert [D] into [src].</span>"
		update_label()

/obj/item/device/tablet/proc/attackby_tablet(obj/item/C, mob/user, params)
	if(!core)
		return 0

	if(istype(C, /obj/item/weapon/cartridge))
		var/obj/item/weapon/cartridge/expand = C
		if(!expand.programs.len)
			user << "<span class='notice'>This cartridge has been used up.</span>"
			return
		user << "<span class='notice'>You load the cartridge's data into the downloads.</span>"
		for(var/P in expand.programs)
			if(add_program(P))
				expand.programs.Remove(P)

	else if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!idcard.registered_name)
			user << "<span class='warning'>\The [src] rejects the ID!</span>"
			return
		if(!owner || !core.owner)
			core.owner = idcard.registered_name
			core.ownjob = idcard.assignment
			update_label()
			user << "<span class='notice'>Card scanned.</span>"
		else
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
			if(((src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_range(src, user) && (C in user.contents)) )
				if(!id_check(user, 2))
					return
				user << "<span class='notice'>You put the ID into \the [src]'s slot.</span>"
				updateSelfDialog()//Update self dialog on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	else if(istype(C, /obj/item/device/paicard) && !src.pai)
		if(!user.unEquip(C))
			return
		C.loc = src
		pai = C
		user << "<span class='notice'>You slot \the [C] into [src].</span>"
		updateUsrDialog()
	else if(istype(C, /obj/item/weapon/pen))
		if(pen)
			user << "<span class='warning'>There is already a pen in \the [src]!</span>"
		else
			if(!user.unEquip(C))
				return
			C.loc = src
			pen = C
			user << "<span class='notice'>You slide \the [C] into \the [src].</span>"
	else
		return 0


/obj/item/device/tablet/proc/attackby_laptop(obj/item/C, mob/user, params)
	return 0

/obj/item/device/tablet/laptop/attackby_laptop(obj/item/C, mob/user, params)
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