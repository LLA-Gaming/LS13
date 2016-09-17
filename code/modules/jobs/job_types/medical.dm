/*
Chief Medical Officer
*/
/datum/job/cmo
	title = "Medical Director"
	flag = CMO
	department_head = list("Station Chief")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the station chief"
	selection_color = "#ffddf0"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/cmo

	access = list(access_medical, access_morgue, access_genetics, access_heads, access_mineral_storeroom,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_maint_tunnels, access_therapy)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_heads, access_mineral_storeroom,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_maint_tunnels, access_therapy)

/datum/outfit/job/cmo
	name = "Medical Director"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/tablet/cmo
	ears = /obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/datum/outfit/job/cmo/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Medical")) //tell underlings (medical radio) they have a head

/*
Medical Doctor
*/
/datum/job/doctor
	title = "Medical Doctor"
	flag = DOCTOR
	department_head = list("Medical Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the medical director"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/doctor

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_morgue, access_surgery)

/datum/outfit/job/doctor
	name = "Medical Doctor"

	belt = /obj/item/device/tablet/medical
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
EMT
*/
/datum/job/EMT
	title = "EMT"
	flag = DOCTOR
	department_head = list("Medical Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the medical director"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/doctor

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_morgue, access_surgery)

/datum/outfit/job/EMT
	name = "EMT"

	belt = /obj/item/device/tablet/medical
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med