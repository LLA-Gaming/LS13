/obj/vehicle/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon_state = "scooter"

/obj/vehicle/scooter/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		user.text2tab("<span class='notice'>You begin to remove the handlebars...</span>")
		playsound(get_turf(user), 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 40/I.toolspeed, target = src))
			new /obj/vehicle/scooter/skateboard(get_turf(src))
			new /obj/item/stack/rods(get_turf(src),2)
			user.text2tab("<span class='notice'>You remove the handlebars from [src].</span>")
			qdel(src)

/obj/vehicle/scooter/handle_vehicle_layer()
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = OBJ_LAYER

/obj/vehicle/scooter/handle_vehicle_offsets()
	..()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			switch(buckled_mob.dir)
				if(NORTH)
					buckled_mob.pixel_x = 0
				if(EAST)
					buckled_mob.pixel_x = -2
				if(SOUTH)
					buckled_mob.pixel_x = 0
				if(WEST)
					buckled_mob.pixel_x = 2
			if(buckled_mob.get_num_legs() > 0)
				buckled_mob.pixel_y = 4
			else
				buckled_mob.pixel_y = -4

/obj/vehicle/scooter/post_buckle_mob(mob/living/M)
	vehicle_move_delay = initial(vehicle_move_delay)
	..()
	if(M.get_num_legs() < 2)
		vehicle_move_delay ++
		if(M.get_num_arms() <= 0)
			if(buckled_mobs.len)//to prevent the message displaying twice due to unbuckling
				M.text2tab("<span class='warning'>Your limbless body flops off \the [src].</span>")
			unbuckle_mob(M)

/obj/vehicle/scooter/skateboard
	name = "skateboard"
	desc = "An unfinished scooter which can only barely be called a skateboard. It's still rideable, but probably unsafe. Looks like you'll need to add a few rods to make handlebars."
	icon_state = "skateboard"
	vehicle_move_delay = 0//fast
	density = 0

/obj/vehicle/scooter/skateboard/post_buckle_mob(mob/living/M)//allows skateboards to be non-dense but still allows 2 skateboarders to collide with each other
	if(has_buckled_mobs())
		density = 1
	else
		density = 0
	..()

/obj/vehicle/scooter/skateboard/Bump(atom/A)
	..()
	if(A.density && has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		var/atom/throw_target = get_edge_target_turf(H, pick(cardinal))
		unbuckle_mob(H)
		H.throw_at_fast(throw_target, 4, 3)
		H.Weaken(5)
		H.adjustStaminaLoss(40)
		visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
		playsound(src, 'sound/effects/bang.ogg', 50, 1)

//CONSTRUCTION
/obj/item/scooter_frame
	name = "scooter frame"
	desc = "A metal frame for building a scooter. Looks like you'll need to add some metal to make wheels."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "scooter_frame"
	w_class = 3

/obj/item/scooter_frame/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		user.text2tab("<span class='notice'>You deconstruct [src].</span>")
		new /obj/item/stack/rods(get_turf(src),10)
		playsound(get_turf(user), 'sound/items/Ratchet.ogg', 50, 1)
		qdel(src)
		return

	else if(istype(I, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = I
		if(M.amount < 5)
			user.text2tab("<span class='warning'>You need at least five metal sheets to make proper wheels!</span>")
			return
		user.text2tab("<span class='notice'>You begin to add wheels to [src].</span>")
		if(do_after(user, 80, target = src))
			M.use(5)
			user.text2tab("<span class='notice'>You finish making wheels for [src].</span>")
			new /obj/vehicle/scooter/skateboard(user.loc)
			qdel(src)

/obj/vehicle/scooter/skateboard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		user.text2tab("<span class='notice'>You begin to deconstruct and remove the wheels on [src]...</span>")
		playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20, target = src))
			user.text2tab("<span class='notice'>You deconstruct the wheels on [src].</span>")
			new /obj/item/stack/sheet/metal(get_turf(src),5)
			new /obj/item/scooter_frame(get_turf(src))
			qdel(src)

	else if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/C = I
		if(C.get_amount() < 2)
			user.text2tab("<span class='warning'>You need at least two rods to make proper handlebars!</span>")
			return
		user.text2tab("<span class='notice'>You begin making handlebars for [src].</span>")
		if(do_after(user, 25, target = src))
			user.text2tab("<span class='notice'>You add the rods to [src], creating handlebars.</span>")
			C.use(2)
			new/obj/vehicle/scooter(get_turf(src))
			qdel(src)


//Skis

/obj/vehicle/scooter/skateboard/ski
	name = "ski board"
	desc = "a yeti's second favorite meal"
	icon_state = "skiboard"
	vehicle_move_delay = 0//fast
	density = 0
	key_noun = "ski poles"
	drive_verb = "ride"
	hands_needed = "both"
	turf_slowdown_needed = list(2) //snow only
	canuse_normalturf = 0

	keycheck(mob/user)
		var/obj/item/weapon/twohanded/skipole/S
		if(istype(user.l_hand, /obj/item/weapon/twohanded/skipole))
			S = user.l_hand
		if(istype(user.r_hand, /obj/item/weapon/twohanded/skipole))
			S = user.r_hand
		if(S && S.wielded)
			return 1

	MouseDrop(over_object, src_location, over_location)
		. = ..()
		if(over_object == usr && Adjacent(usr))
			if(!ishuman(usr) || has_buckled_mobs() || src.flags & NODECONSTRUCT)
				return
			if(usr.incapacitated())
				usr.text2tab("<span class='warning'>You can't do that right now!</span>")
				return
			usr.visible_message("<span class='notice'>[usr] picks up \the [src.name].</span>", "<span class='notice'>You pick up \the [src.name].</span>")
			var/C = new /obj/item/weapon/ski(loc)
			usr.put_in_hands(C)
			qdel(src)


/obj/item/weapon/ski
	name = "ski board"
	desc = "a yeti's second favorite meal"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "skiitem"
	w_class = 5
	force = 8
	throwforce = 10
	throw_range = 3
	hitsound = 'sound/items/trayhit1.ogg'

	attack_self(mob/user)
		for(var/obj/A in get_turf(loc))
			if(A.density && !(A.flags & ON_BORDER))
				user.text2tab("<span class='danger'>There is already something here.</span>")
				return

		user.visible_message("<span class='notice'>[user] places \the [src.name].</span>", "<span class='notice'>You place \the [name].</span>")
		new /obj/vehicle/scooter/skateboard/ski(get_turf(loc))
		qdel(src)

/obj/item/weapon/twohanded/skipole
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "skipole0"
	name = "ski poles"
	desc = "use this to freely ski around on the snow"
	force = 5
	throwforce = 15
	w_class = 3
	var/w_class_on = 4
	force_unwielded = 5
	force_wielded = 5

	wield(mob/living/carbon/M)
		w_class = w_class_on
		..()

	unwield()
		w_class = initial(w_class)
		..()

	update_icon()
		icon_state = "skipole[wielded]"