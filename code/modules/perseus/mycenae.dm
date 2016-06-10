/*
* All ship related stuff goes here.
*/

/datum/configuration/var/mycenae_starts_at_centcom = 0

/area/security/perseus/mycenaeiii
	name = "Perseus Ship: The Mycenae"
	icon_state = "perseus"
	lighting_use_dynamic = 0
	requires_power = 0
	has_gravity = 1
	power_equip = 1

	New()
		..()
		spawn(5)
			power_equip = 1
/*
* Decal Nameplate
*/

/obj/structure/sign/mycenae
	desc = "The name plate of the ship.'"
	name = "Mycenae"
	icon = 'icons/obj/decals.dmi'
	icon_state = "perc1"
	anchored = 1.0
	opacity = 0
	density = 0

/*
* Enforcer Locker
*/

/obj/structure/closet/secure_closet/enforcer
	name = "Perseus Enforcer Equipment"
	req_access = list(access_penforcer)
	icon_state = "enforcer"

	New()
		..()
		new /obj/item/clothing/shoes/combat(src)
		new /obj/item/clothing/suit/armor/lightarmor(src)
		new /obj/item/clothing/head/helmet/space/pershelmet(src)
		new /obj/item/clothing/mask/chameleon/perseus(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/device/assembly/flash/handheld(src)
		new /obj/item/weapon/restraints/handcuffs(src)
		new /obj/item/weapon/shield/riot/perc(src)
		new /obj/item/weapon/gun/energy/ep90(src)
		new /obj/item/weapon/stun_knife(src)
		new /obj/item/weapon/stock_parts/cell/magazine/ep90(src)


/*
* Commander Locker
*/

/obj/structure/closet/secure_closet/commander
	name = "Perseus Commander Equipment"
	req_access = list(access_pcommander)
	icon_state = "commander"

	New()
		..()
		new /obj/item/clothing/under/perseus_fatigues(src)
		new /obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey(src)
		new /obj/item/clothing/head/helmet/space/beret/perseus(src)
		new /obj/item/clothing/shoes/combat(src)
		new /obj/item/clothing/under/space/skinsuit(src)
		new /obj/item/clothing/suit/armor/lightarmor(src)
		new /obj/item/clothing/mask/chameleon/perseus(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/ammo_box/magazine/fiveseven(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/device/assembly/flash/handheld(src)
		new /obj/item/weapon/restraints/handcuffs(src)
		new /obj/item/weapon/shield/riot/perc(src)
		new /obj/item/weapon/gun/energy/ep90(src)
		new /obj/item/weapon/gun/projectile/automatic/fiveseven(src)
		new /obj/item/weapon/stun_knife(src)
		return

/*
* Mixed Locker
*/

/obj/structure/closet/perseus/mixed
	name = "Mixed Closet"

	New()
		..()
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)

/*
* Barrier
*/

/obj/structure/barricade/security/perseus
	name = "PercTech Deployable Barrier"
	desc = "A PercTech deployable barrier. Swipe your Dogtags to lock/unlock it."
	icon_state = "barrier0"

	req_access = list(access_penforcer)

/*
* Evidence Locker
*/

/obj/structure/closet/secure_closet/p_evidence
	name = "PercTech Evidence Locker"
	desc = "A wall mounted locker."
	icon_state = "p_wall_closet"
	wall_mounted = 1
	req_access = list(access_penforcer)
	large = 0

/*
* Perseus Armory Wall-Locker
*/

/obj/structure/closet/secure_closet/p_armory
	name = "perseus armory locker"
	desc = "A wall mounted locker."
	icon_state = "p_armory_wall_closet"
	wall_mounted = 1
	req_access = list(access_pcommander)
	large = 0

/*
* Mycenae Moving
*/

/area/security/perseus/mycenae_centcom
	name = "Mycenae Centcom Position"
	icon_state = "perseus_centcom"
	lighting_use_dynamic = 0
	requires_power = 0
	has_gravity = 1

var/mycenae_at_centcom = 1
var/perseus_shuttle_locked = 1

/proc/move_mycenae()
	if(mycenae_at_centcom)
		mycenae_at_centcom = 0
		var/area/start_location = locate(/area/security/perseus/mycenae_centcom)
		var/area/normal_location = locate(/area/security/perseus/mycenaeiii)
		spawn(5)
			start_location.move_contents_to(normal_location)
			spawn(5)
				for(var/obj/machinery/telecomms/relay/preset/M in world)
					if(M.id == "Perseus Relay")
						M.listening_level = 3


/*
* Prison Shuttle
*/

/area/shuttle/prison/station
	name = "Prison Shuttle"
	icon_state = "shuttle"
	has_gravity = 1

/area/shuttle/prison/prison
	name = "Prison Shuttle"
	icon_state = "shuttle2"
	has_gravity = 1

var/perseusShuttleAtMycenae = 0
var/perseusShuttleMoving = 0

#define PERSEUS_SHUTTLE_MYCENAE_AREA /area/shuttle/prison/prison
#define PERSEUS_SHUTTLE_STATION_AREA /area/shuttle/prison/station

/obj/machinery/computer/shuttle/perseus
	name = "Prison Shuttle Console"
	req_one_access = list(access_security, access_penforcer, access_pcommander)
	shuttleId = "perseus_shuttle"
	possible_destinations = "perseus_station;perseus_mycenae"
	no_destination_swap = 0

	attack_hand(var/mob/living/user)
		src.add_fingerprint(user)

		if(mycenae_at_centcom)
			user << "<span class='warning'>The [src] failed to establish a connection to the prison shuttle.</span>"
			return 0

		if(perseus_shuttle_locked && !emagged)
			user << "<span class='warning'>The [src] is locked!</span>"
			return 0

		..(user)

