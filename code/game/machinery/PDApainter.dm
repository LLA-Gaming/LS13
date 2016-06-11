/obj/machinery/pdapainter
	name = "\improper tablet painter"
	desc = "A tablet painting machine. To use, simply insert your tablet and choose the desired preset paint scheme."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdapainter"
	density = 1
	anchored = 1
	var/obj/item/device/tablet/stored = null
	var/list/colorlist = list()
	var/health = 100


/obj/machinery/pdapainter/update_icon()
	overlays.Cut()

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return

	if(stored)
		overlays += "[initial(icon_state)]-closed"

	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

	return

/obj/machinery/pdapainter/New()
	..()
	var/blocked = list(/obj/item/device/tablet/pai,
						 /obj/item/device/tablet/ai,
						 /obj/item/device/tablet/captain,
						 /obj/item/device/tablet/hop,
						 /obj/item/device/tablet/hos,
						 /obj/item/device/tablet/captain,
						 /obj/item/device/tablet/cmo,
						 /obj/item/device/tablet/ce,
						 /obj/item/device/tablet/rd,
						 /obj/item/device/tablet/clear,
						 /obj/item/device/tablet/syndi,
						 /obj/item/device/tablet/laptop,
						 /obj/item/device/tablet/perseus)

	for(var/P in typesof(/obj/item/device/tablet)-blocked)
		var/obj/item/device/tablet/D = new P(src,1)

		//D.name = "PDA Style [colorlist.len+1]" //Gotta set the name, otherwise it all comes up as "PDA"
		D.name = D.icon_state //PDAs don't have unique names, but using the sprite names works.

		src.colorlist += D


/obj/machinery/pdapainter/attackby(obj/item/O, mob/user, params)
	if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/device/tablet))
		if(stored)
			user.text2tab("<span class='warning'>There is already a tablet inside!</span>")
			return
		else
			var/obj/item/device/tablet/P = user.get_active_hand()
			if(istype(P))
				if(!user.drop_item())
					return
				stored = P
				P.loc = src
				P.add_fingerprint(user)
				update_icon()

	else if(istype(O, /obj/item/weapon/weldingtool) && user.a_intent != "harm")
		var/obj/item/weapon/weldingtool/WT = O
		if(stat & BROKEN)
			if(WT.remove_fuel(0,user))
				user.visible_message("[user] is repairing [src].", \
								"<span class='notice'>You begin repairing [src]...</span>", \
								"<span class='italics'>You hear welding.</span>")
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
				if(do_after(user,40/WT.toolspeed, 1, target = src))
					if(!WT.isOn() || !(stat & BROKEN))
						return
					user.text2tab("<span class='notice'>You repair [src].</span>")
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					stat &= ~BROKEN
					health = initial(health)
					update_icon()
		else
			user.text2tab("<span class='notice'>[src] does not need repairs.</span>")
	else
		return ..()

/obj/machinery/pdapainter/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(damage)
					playsound(loc, 'sound/weapons/smash.ogg', 50, 1)
				else
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			if(sound_effect)
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		else
			return
	if(!(stat & BROKEN))
		health -= damage
		if(health <= 0)
			stat |= BROKEN
			update_icon()

/obj/machinery/pdapainter/attack_hand(mob/user)
	if(!..())
		add_fingerprint(user)

		if(stored)
			var/obj/item/device/tablet/P
			P = input(user, "Select your color!", "Tablet Painting") as null|anything in colorlist
			if(!P)
				return
			if(!in_range(src, user))
				return
			if(!stored)//is the pda still there?
				return
			stored.icon_state = P.icon_state
			stored.desc = P.desc
			ejectpda()

		else
			user.text2tab("<span class='notice'>\The [src] is empty.</span>")


/obj/machinery/pdapainter/verb/ejectpda()
	set name = "Eject Tablet"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.restrained() || !usr.canmove)
		return

	if(stored)
		stored.loc = get_turf(src.loc)
		stored = null
		update_icon()
	else
		usr.text2tab("<span class='notice'>The [src] is empty.</span>")


/obj/machinery/pdapainter/power_change()
	..()
	update_icon()
