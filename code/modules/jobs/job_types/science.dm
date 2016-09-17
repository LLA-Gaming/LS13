/*
Lead Scientist
*/
/datum/job/rd
	title = "Lead Scientist"
	flag = RD
	department_head = list("Station Chief")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the station chief"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/rd

	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload,
			            access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom,
			            access_tech_storage, access_minisat, access_maint_tunnels)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload,
			            access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom,
			            access_tech_storage, access_minisat, access_maint_tunnels)

/datum/outfit/job/rd
	name = "Lead Scientist"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/tablet/rd
	ears = /obj/item/device/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/rank/research_director
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/weapon/clipboard
	l_pocket = /obj/item/device/laser_pointer
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/science
	satchel = /obj/item/weapon/storage/backpack/satchel_tox

/datum/outfit/job/rd/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Science")) //tell underlings (science radio) they have a head

/*
Scientist
*/
/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department_head = list("Lead Scientist")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the lead scientist"
	selection_color = "#ffeeff"

	outfit = /datum/outfit/job/scientist

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_mineral_storeroom, access_tech_storage, access_genetics)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_mineral_storeroom)

/datum/outfit/job/scientist
	name = "Scientist"

	belt = /obj/item/device/tablet/science
	ears = /obj/item/device/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/toggle/labcoat/science

	backpack = /obj/item/weapon/storage/backpack/science
	satchel = /obj/item/weapon/storage/backpack/satchel_tox


/*
Chemist
*/
/datum/job/chemist
	title = "Chemist"
	flag = CHEMIST
	department_head = list("Lead Scientist")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the lead scientist"
	selection_color = "#ffeeff"

	outfit = /datum/outfit/job/chemist

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_chemistry, access_mineral_storeroom)

/datum/outfit/job/chemist
	name = "Chemist"

	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/device/tablet/chemist
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist

	backpack = /obj/item/weapon/storage/backpack/chemistry
	satchel = /obj/item/weapon/storage/backpack/satchel_chem
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Geneticist
*/
/datum/job/geneticist
	title = "Geneticist"
	flag = GENETICIST
	department_head = list("Medical Director", "Lead Scientist")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the lead scientist"
	selection_color = "#ffeeff"

	outfit = /datum/outfit/job/geneticist

	access = list(access_medical, access_morgue, access_chemistry, access_virology, access_genetics, access_research, access_xenobiology, access_robotics, access_mineral_storeroom, access_tech_storage)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)

/datum/outfit/job/geneticist
	name = "Geneticist"

	belt = /obj/item/device/tablet/genetics
	ears = /obj/item/device/radio/headset/headset_medsci
	uniform = /obj/item/clothing/under/rank/geneticist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/genetics
	suit_store =  /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/genetics
	satchel = /obj/item/weapon/storage/backpack/satchel_gen
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Virologist
*/
/datum/job/virologist
	title = "Virologist"
	flag = VIROLOGIST
	department_head = list("Lead Scientist")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the lead scientist"
	selection_color = "#ffeeff"

	outfit = /datum/outfit/job/virologist

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_virology, access_mineral_storeroom)

/datum/outfit/job/virologist
	name = "Virologist"

	belt = /obj/item/device/tablet/virology
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/virologist
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/virologist
	suit_store =  /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/virology
	satchel = /obj/item/weapon/storage/backpack/satchel_vir
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Botanist
*/
/datum/job/hydro
	title = "Agronomist"
	flag = BOTANIST
	department_head = list("Lead Scientist")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the lead scientist"
	selection_color = "#ffeeff"

	outfit = /datum/outfit/job/botanist

	access = list(access_hydroponics, access_bar, access_kitchen, access_morgue) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
	minimal_access = list(access_hydroponics, access_morgue) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.

/datum/outfit/job/botanist
	name = "Agronomist"

	belt = /obj/item/device/tablet/hydro
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves  =/obj/item/clothing/gloves/botanic_leather
	suit_store = /obj/item/device/plant_analyzer

	backpack = /obj/item/weapon/storage/backpack/botany
	satchel = /obj/item/weapon/storage/backpack/satchel_hyd
