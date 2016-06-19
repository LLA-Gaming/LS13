/*
* Fabricator Circuit Board
*/

/obj/item/weapon/circuitboard/machine/podfab
	name = "circuit board (Pod Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator/pod
	origin_tech = "programming=3;engineering=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/*
* Pod Fabricator
*/

/obj/machinery/mecha_part_fabricator/pod
	name = "space pod fabricator"
	icon_state = "pod-fab"
	production_type = PODFAB
	req_access = list()
	board_type = /obj/item/weapon/circuitboard/machine/podfab

	GetPartSets()
		var/list/categories = list()
		for(var/datum/design/D in files.possible_designs)
			if(D.build_type & PODFAB)
				for(var/category in D.category)
					if(category in categories)
						continue
					categories += category

		return categories

/*
* RnD Console
*/

/obj/machinery/computer/rdconsole/podbay
	name = "Pod Manufacturing R&D Console"
	id = 3
	req_access = list()
