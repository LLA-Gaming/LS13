/*
Quartermaster
*/
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the station chief"
	selection_color = "#d7b088"

	outfit = /datum/outfit/job/quartermaster

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_mineral_storeroom)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_mineral_storeroom)

/datum/outfit/job/quartermaster
	name = "Quartermaster"

	belt = /obj/item/device/tablet/qm
	ears = /obj/item/device/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargo
	shoes = /obj/item/clothing/shoes/sneakers/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/weapon/clipboard

/*
Cargo Technician
*/
/datum/job/cargo_tech
	title = "Supply Technician"
	flag = CARGOTECH
	department_head = list("Quartermaster")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the quartermaster"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/cargo_tech

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_mineral_storeroom)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting, access_mineral_storeroom)

/datum/outfit/job/cargo_tech
	name = "Supply Technician"

	belt = /obj/item/device/tablet/cargo
	ears = /obj/item/device/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargotech


/*
Mining Tech
*/
/datum/job/mining
	title = "Mining Technician"
	flag = MINER
	department_head = list("Quartermaster")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/miner

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_mineral_storeroom)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting, access_mineral_storeroom)

/datum/outfit/job/miner
	name = "Mining Technician"

	belt = /obj/item/device/tablet/miner
	ears = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/miner/lavaland
	l_pocket = /obj/item/weapon/reagent_containers/pill/patch/styptic
	backpack_contents = list(/obj/item/weapon/crowbar=1,\
		/obj/item/weapon/storage/bag/ore=1,\
		/obj/item/device/flashlight/seclite=1,\
		/obj/item/weapon/kitchen/knife/combat/survival=1,\
		/obj/item/weapon/mining_voucher=1)

	backpack = /obj/item/weapon/storage/backpack/explorer
	satchel = /obj/item/weapon/storage/backpack/satchel_explorer
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag
	box = /obj/item/weapon/storage/box/engineer

/*
Salvage Tech
*/
/datum/job/salvage
	title = "Salvage Technician"
	flag = MINER
	department_head = list("Quartermaster")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/miner

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_mineral_storeroom)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting, access_mineral_storeroom)

/datum/outfit/job/salvage
	name = "Salvage Technician"

	belt = /obj/item/device/tablet/miner
	ears = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/miner/lavaland
	l_pocket = /obj/item/weapon/reagent_containers/pill/patch/styptic
	backpack_contents = list(/obj/item/weapon/crowbar=1,\
		/obj/item/weapon/storage/bag/ore=1,\
		/obj/item/device/flashlight/seclite=1,\
		/obj/item/weapon/kitchen/knife/combat/survival=1,\
		/obj/item/weapon/mining_voucher=1)

	backpack = /obj/item/weapon/storage/backpack/explorer
	satchel = /obj/item/weapon/storage/backpack/satchel_explorer
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag
	box = /obj/item/weapon/storage/box/engineer


/*
Bartender
*/
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "human resources"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/bartender

	access = list(access_hydroponics, access_bar, access_kitchen, access_morgue, access_weapons)
	minimal_access = list(access_bar)


/datum/outfit/job/bartender
	name = "Bartender"

	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	belt = /obj/item/device/tablet/bartender
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/bartender
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(/obj/item/weapon/storage/box/beanbag=1)
	shoes = /obj/item/clothing/shoes/laceup

/*
Cook
*/
/datum/job/cook
	title = "Chef"
	flag = COOK
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "human resources"
	selection_color = "#bbe291"
	var/cooks = 0 //Counts cooks amount

	outfit = /datum/outfit/job/cook

	access = list(access_hydroponics, access_bar, access_kitchen, access_morgue)
	minimal_access = list(access_kitchen, access_morgue)

/datum/outfit/job/cook
	name = "Chef"

	belt = /obj/item/device/tablet/cook
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/toggle/chef
	head = /obj/item/clothing/head/chefhat

/datum/outfit/job/cook/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/job/cook/J = SSjob.GetJob(H.job)
	if(J) // Fix for runtime caused by invalid job being passed
		J.cooks++
		if(J.cooks>1)//Cooks
			suit = /obj/item/clothing/suit/apron/chef
			head = /obj/item/clothing/head/soft/mime

/datum/outfit/job/cook/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    ..()
    var/list/possible_boxes = subtypesof(/obj/item/weapon/storage/box/ingredients)
    var/chosen_box = pick(possible_boxes)
    var/obj/item/weapon/storage/box/I = new chosen_box(src)
    H.equip_to_slot_or_del(I,slot_in_backpack)

/*
Janitor
*/
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "human resources"
	selection_color = "#bbe291"
	var/global/janitors = 0

	outfit = /datum/outfit/job/janitor

	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

/datum/outfit/job/janitor
	name = "Janitor"

	belt = /obj/item/device/tablet/janitor
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/janitor
