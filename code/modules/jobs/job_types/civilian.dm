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

/*
Clown
*/
/datum/job/clown
	title = "Clown"
	flag = CLOWN
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "human resources"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/clown

	access = list(access_theatre)
	minimal_access = list(access_theatre)

/datum/outfit/job/clown
	name = "Clown"

	belt = /obj/item/device/tablet/clown
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/weapon/bikehorn
	r_pocket = /obj/item/toy/crayon/rainbow
	backpack_contents = list(
		/obj/item/weapon/stamp/clown = 1,
		/obj/item/weapon/reagent_containers/spray/waterflower = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/device/megaphone/clown = 1
		)

	backpack = /obj/item/weapon/storage/backpack/clown
	satchel = /obj/item/weapon/storage/backpack/clown
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/clown //strangely has a duffle

/datum/outfit/job/clown/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	H.fully_replace_character_name(H.real_name, pick(clown_names))

/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/weapon/implant/sad_trombone/S = new/obj/item/weapon/implant/sad_trombone(H)
	S.imp_in = H
	S.implanted = 1

	H.dna.add_mutation(CLOWNMUT)
	H.rename_self("clown")

/*
Mime
*/
/datum/job/mime
	title = "Mime"
	flag = MIME
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "human resources"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/mime

	access = list(access_theatre)
	minimal_access = list(access_theatre)

/datum/outfit/job/mime
	name = "Mime"

	belt = /obj/item/device/tablet/mime
	uniform = /obj/item/clothing/under/rank/mime
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/beret
	suit = /obj/item/clothing/suit/suspenders
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing=1,\
		/obj/item/toy/crayon/mime=1)

	backpack = /obj/item/weapon/storage/backpack/mime
	satchel = /obj/item/weapon/storage/backpack/mime


/datum/outfit/job/mime/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak(null))
		H.mind.miming = 1

	H.rename_self("mime")

/*
Librarian
*/
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "human resources"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/librarian

	access = list(access_library)
	minimal_access = list(access_library)

/datum/outfit/job/librarian
	name = "Librarian"

	belt = /obj/item/device/tablet/library
	uniform = /obj/item/clothing/under/rank/librarian
	l_hand = /obj/item/weapon/storage/bag/books
	r_pocket = /obj/item/weapon/barcodescanner
	l_pocket = /obj/item/device/laser_pointer

/*
Lawyer
*/
/datum/job/lawyer
	title = "Lawyer"
	flag = LAWYER
	department_head = list("Human Resources")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "human resources"
	selection_color = "#dddddd"
	var/lawyers = 0 //Counts lawyer amount

	outfit = /datum/outfit/job/lawyer

	access = list(access_lawyer, access_court, access_sec_doors)
	minimal_access = list(access_lawyer, access_court, access_sec_doors)

/datum/outfit/job/lawyer
	name = "Lawyer"

	belt = /obj/item/device/tablet/lawyer
	ears = /obj/item/device/radio/headset/headset_sec
	uniform = /obj/item/clothing/under/lawyer/bluesuit
	suit = /obj/item/clothing/suit/toggle/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/weapon/storage/briefcase/lawyer
	l_pocket = /obj/item/device/laser_pointer

/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/datum/job/lawyer/J = SSjob.GetJob(H.job)
	J.lawyers++
	if(J.lawyers>1)
		uniform = /obj/item/clothing/under/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple
