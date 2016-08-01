/datum/wires/telepad
	holder_type = /obj/machinery/telepad

/datum/wires/telepad/New(atom/holder)
	wires = list(
		WIRE_ACTIVATE, WIRE_SEND_RECEIVE,
		WIRE_CALIBRATE, WIRE_LINK
	)
	..()

/datum/wires/telepad/interactable(mob/user)
	var/obj/machinery/telepad/T = holder
	if(T.panel_open)
		return TRUE

/datum/wires/telepad/get_status()
	var/obj/machinery/telepad/T = holder
	var/list/status = list()
	status += "The green light is [T.computer ? "on" : "off"]."
	status += "The red light is [T.cant_activate ? "on" : "off"]."
	status += "The orange light is [T.cant_switch ? "on" : "off"]."
	status += "The purple light is [T.cant_calibrate ? "on" : "off"]."
	status += "The yellow light is [T.cant_link ? "on" : "off"]."
	if(T.computer)
		status += "A [T.computer.sending ? "light blue" : "dark blue"] light is on."
	return status

/datum/wires/telepad/on_pulse(wire)
	var/obj/machinery/telepad/T = holder
	var/obj/machinery/computer/telescience/C = T.computer
	switch(wire)
		if(WIRE_ACTIVATE)
			if(T.computer)
				C.teleport(usr)
		if(WIRE_SEND_RECEIVE)
			if(T.computer)
				C.sending = !C.sending
		if(WIRE_CALIBRATE)
			if(T.computer)
				C.recalibrate()
				C.sparks()
		if(WIRE_LINK)
			if(T.computer)
				C.telepad = null
				T.computer = null

/datum/wires/telepad/on_cut(wire, mend)
	var/obj/machinery/telepad/T = holder
	switch(wire)
		if(WIRE_ACTIVATE)
			T.cant_activate = !mend
		if(WIRE_SEND_RECEIVE)
			T.cant_switch = !mend
		if(WIRE_CALIBRATE)
			T.cant_calibrate = !mend
		if(WIRE_LINK)
			T.cant_link = !mend
			if(T.computer)
				T.computer.telepad = null
				T.computer = null