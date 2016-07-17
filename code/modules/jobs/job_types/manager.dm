/*
Station Manager
*/
/datum/job/manager
	title = "Station Manager"
	flag = MANAGER
	department_head = list("Centcom")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Nanotrasen officials and Space law"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14

	outfit = /datum/outfit/job/manager

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/manager/get_access()
	return get_all_accesses()


/datum/outfit/job/manager
	name = "Station Manager"

	id = /obj/item/weapon/card/id/gold
	belt = /obj/item/device/tablet/manager
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/manager/alt
	gloves = /obj/item/clothing/gloves/color/manager
	uniform =  /obj/item/clothing/under/rank/manager
	suit = /obj/item/clothing/suit/hooded/wintercoat/manager
	shoes = /obj/item/clothing/shoes/winterboots
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1, /obj/item/station_charter=1)

	backpack = /obj/item/weapon/storage/backpack/manager
	satchel = /obj/item/weapon/storage/backpack/satchel_manager
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/manager

/datum/outfit/job/manager/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	var/obj/item/clothing/under/U = H.w_uniform
	U.attachTie(new /obj/item/clothing/tie/medal/gold/manager())

	if(visualsOnly)
		return

	var/obj/item/weapon/implant/mindshield/L = new/obj/item/weapon/implant/mindshield(H)
	L.imp_in = H
	L.implanted = 1
	H.sec_hud_set_implants()

	minor_announce("Station Manager [H.real_name] on duty!")

/*
Head of Personnel
*/
/datum/job/human_resources
	title = "Human Resources"
	flag = HUMANRESOURCE
	department_head = list("Station Manager")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the station manager"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10

	outfit = /datum/outfit/job/human_resources

	access = list(access_security, access_sec_doors, access_court, access_weapons,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hr, access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom)
	minimal_access = list(access_security, access_sec_doors, access_court, access_weapons,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hr, access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom)


/datum/outfit/job/human_resources
	name = "Human Resources"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/tablet/hr
	ears = /obj/item/device/radio/headset/heads/hr
	uniform = /obj/item/clothing/under/rank/human_resources
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/hrcap
	backpack_contents = list(/obj/item/weapon/storage/box/ids=1,\
		/obj/item/weapon/melee/classic_baton/telescopic=1)

/datum/outfit/job/human_resources/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Supply", "Service"))
