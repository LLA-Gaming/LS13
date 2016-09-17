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
