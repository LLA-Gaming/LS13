//"immutable" gas mixture used for planet gas calculations
//it can be changed, but any changes will ultimately be undone before they can have any effect

/datum/gas_mixture/planet

/datum/gas_mixture/planet/New()
	..()
	temperature = TCMB
	temperature_archived = TCMB

/datum/gas_mixture/planet/garbage_collect()
	gases.Cut() //clever way of ensuring we always are empty.

/datum/gas_mixture/planet/archive()
	return 1 //nothing changes, so we do nothing and the archive is successful

/datum/gas_mixture/planet/merge()
	return 0 //we're immutable.

/datum/gas_mixture/planet/heat_capacity()
	. = 7000

/datum/gas_mixture/planet/heat_capacity_archived()
	. = heat_capacity()

/datum/gas_mixture/planet/remove()
	return copy() //we're immutable, so we can just return a copy.

/datum/gas_mixture/planet/remove_ratio()
	return copy() //we're immutable, so we can just return a copy.

/datum/gas_mixture/planet/share(datum/gas_mixture/sharer, atmos_adjacent_turfs = 4)
	. = ..(sharer, 0)
	temperature = TCMB
	gases.Cut()

/datum/gas_mixture/planet/after_share()
	temperature = TCMB
	gases.Cut()

/datum/gas_mixture/planet/react()
	return 0 //we're immutable.

/datum/gas_mixture/planet/fire()
	return 0 //we're immutable.

/datum/gas_mixture/planet/copy()
	return new /datum/gas_mixture/planet //we're immutable, so we can just return a new instance.

/datum/gas_mixture/planet/copy_from()
	return 0 //we're immutable.

/datum/gas_mixture/planet/copy_from_turf()
	return 0 //we're immutable.

/datum/gas_mixture/planet/parse_gas_string()
	return 0 //we're immutable.

/datum/gas_mixture/planet/temperature_share(datum/gas_mixture/sharer, conduction_coefficient, sharer_temperature, sharer_heat_capacity)
	. = ..()
	temperature = TCMB
