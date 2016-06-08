var/global/list/obj/item/device/pda/all_tablets = list()

/obj/item/device/tablet
	name = "\improper tablet"
	desc = "A portable computer by Thinktronic Systems, LTD."
	icon = 'icons/obj/tablets.dmi'
	icon_state = "tablet"
	item_state = "electronic"

	w_class = 1.0
	slot_flags = SLOT_ID | SLOT_BELT
	var/size_w = 480
	var/size_h = 640
	var/device_type = "Tablet"

	var/default_cartridge
	var/obj/item/weapon/card/id/id
	var/obj/item/weapon/pen/pen
	var/datum/program/loaded
	var/obj/item/device/tablet_core/core
	var/obj/item/device/paicard/pai = null	// A slot for a personal AI device
	var/list/preload_programs = list(/datum/program/toggles/camera,/datum/program/atmosscan)
	var/emped
	var/last_text //No text spamming

	//settings
	var/owner
	var/ownjob
	var/lock_code
	var/fon
	var/hidden
	var/silent
	var/messengeron = 1
	var/candetonate = 0

	//laptop vars
	var/mounted
	var/bolted

/obj/item/device/tablet/laptop
	name = "Laptop"
	icon = 'icons/obj/Laptop.dmi'
	icon_state = "Laptop_closed"
	w_class = 3
	slot_flags = SLOT_BELT

	size_w = 640
	size_h = 480
	device_type = "Laptop"
	preload_programs = list()

//New()
/obj/item/device/tablet/New()
	..()
	all_tablets.Add(src)
	core = new(src)
	pen = new(src)
	//Setup credentials
	core.tablet = src
	core.owner = owner
	core.ownjob = ownjob
	//Install built-in apps
	for(var/X in typesof(/datum/program/builtin) - /datum/program/builtin)
		add_program(X)
	//Install device specific apps
	for(var/X in preload_programs)
		add_program(X)
	//Install cartridge apps
	if(default_cartridge)
		var/obj/item/weapon/cartridge/preload = new	default_cartridge(src)
		for(var/program in preload.programs)
			add_program(program)
		qdel(preload)

/obj/item/device/tablet/Destroy()
	all_tablets.Remove(src)
	..()

//Tablet flavors//
/obj/item/device/tablet/medical
	icon_state = "tablet-medical"
	default_cartridge = /obj/item/weapon/cartridge/medical

/obj/item/device/tablet/therapist
	icon_state = "tablet-medical"
	default_cartridge = /obj/item/weapon/cartridge/medical

/obj/item/device/tablet/virology
	icon_state = "tablet-virology"
	default_cartridge = /obj/item/weapon/cartridge/medical

/obj/item/device/tablet/security
	icon_state = "tablet-security"
	default_cartridge = /obj/item/weapon/cartridge/security

/obj/item/device/tablet/captain
	icon_state = "tablet-captain"
	default_cartridge = /obj/item/weapon/cartridge/captain

/obj/item/device/tablet/chaplain
	icon_state = "tablet-chaplain"

/obj/item/device/tablet/clown
	icon_state = "tablet-clown"
	desc = "A portable computer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	default_cartridge = /obj/item/weapon/cartridge/clown

	Crossed(AM as mob|obj) //Clown Tablet is slippery.
		if (istype(AM, /mob/living/carbon))
			var/mob/living/carbon/M = AM
			M.slip(0, 6, src, NO_SLIP_WHEN_WALKING)


/obj/item/device/tablet/engineer
	icon_state = "tablet-engineer"
	default_cartridge = /obj/item/weapon/cartridge/engineering

/obj/item/device/tablet/janitor
	icon_state = "tablet-janitor"
	default_cartridge = /obj/item/weapon/cartridge/janitor

/obj/item/device/tablet/science
	icon_state = "tablet-science"
	default_cartridge = /obj/item/weapon/cartridge/signal/toxins

/obj/item/device/tablet/qm
	icon_state = "tablet-qm"
	default_cartridge = /obj/item/weapon/cartridge/quartermaster

/obj/item/device/tablet/mime
	icon_state = "tablet-mime"
	default_cartridge = /obj/item/weapon/cartridge/mime

/obj/item/device/tablet/hop
	icon_state = "tablet-hop"
	default_cartridge = /obj/item/weapon/cartridge/hop

/obj/item/device/tablet/ce
	icon_state = "tablet-ce"
	default_cartridge = /obj/item/weapon/cartridge/ce

/obj/item/device/tablet/cmo
	icon_state = "tablet-cmo"
	default_cartridge = /obj/item/weapon/cartridge/cmo

/obj/item/device/tablet/rd
	icon_state = "tablet-rd"
	default_cartridge = /obj/item/weapon/cartridge/rd

/obj/item/device/tablet/hos
	icon_state = "tablet-hos"
	default_cartridge = /obj/item/weapon/cartridge/hos

/obj/item/device/tablet/lawyer
	icon_state = "tablet-lawyer"
	default_cartridge = /obj/item/weapon/cartridge/lawyer

/obj/item/device/tablet/hydro
	icon_state = "tablet-hydro"

/obj/item/device/tablet/roboticist
	icon_state = "tablet-roboticist"
	default_cartridge = /obj/item/weapon/cartridge/roboticist

/obj/item/device/tablet/miner
	icon_state = "tablet-miner"

/obj/item/device/tablet/library
	icon_state = "tablet-library"
	default_cartridge = /obj/item/weapon/cartridge/librarian

/obj/item/device/tablet/atmos
	icon_state = "tablet-atmos"
	default_cartridge = /obj/item/weapon/cartridge/atmos

/obj/item/device/tablet/genetics
	icon_state = "tablet-genetics"
	default_cartridge = /obj/item/weapon/cartridge/medical

/obj/item/device/tablet/chemist
	icon_state = "tablet-chemistry"
	default_cartridge = /obj/item/weapon/cartridge/chemistry

/obj/item/device/tablet/warden
	icon_state = "tablet-warden"
	default_cartridge = /obj/item/weapon/cartridge/security

/obj/item/device/tablet/bartender
	icon_state = "tablet-bartender"

/obj/item/device/tablet/cargo
	icon_state = "tablet-cargo"
	default_cartridge = /obj/item/weapon/cartridge/quartermaster

/obj/item/device/tablet/cook
	icon_state = "tablet-chef"

/obj/item/device/tablet/detective
	icon_state = "tablet-detective"
	default_cartridge = /obj/item/weapon/cartridge/detective

/obj/item/device/tablet/clear
	icon_state = "tablet-clear"

/obj/item/device/tablet/syndicate
	icon_state = "tablet-syndi"
	default_cartridge = /obj/item/weapon/cartridge/syndicate

/obj/item/device/tablet/perseus
	icon_state = "tablet-perc"

/obj/item/device/tablet/ai

/obj/item/device/tablet/pai
