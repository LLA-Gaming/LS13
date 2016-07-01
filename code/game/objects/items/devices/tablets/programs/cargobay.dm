/datum/program/cargobay
	name = "Cargo Bay Monitor"
	app_id = "cargocontrol"
	usesalerts = 1

	use_app()
		dat = "<h4>Supply Record Interlink</h4>"

		dat += "<BR><B>Supply shuttle</B><BR>"
		dat += "Location: "
		switch(SSshuttle.supply.mode)
			if(SHUTTLE_CALL)
				dat += "Moving to "
				if(SSshuttle.supply.z != ZLEVEL_STATION)
					dat += "station"
				else
					dat += "centcomm"
				dat += " ([SSshuttle.supply.timeLeft(600)] Mins)"
			else
				dat += "At "
				if(SSshuttle.supply.z != ZLEVEL_STATION)
					dat += "centcomm"
				else
					dat += "station"
		dat += "<BR>Current approved orders: <BR><ol>"
		for(var/S in SSshuttle.shoppinglist)
			var/datum/supply_order/SO = S
			dat += "<li>#[SO.id] - [SO.pack.name] approved by [SO.orderer] [SO.reason ? "([SO.reason])":""]</li>"
		dat += "</ol>"

		dat += "Current requests: <BR><ol>"
		for(var/S in SSshuttle.requestlist)
			var/datum/supply_order/SO = S
			dat += "<li>#[SO.id] - [SO.pack.name] requested by [SO.orderer]</li>"
		dat += "</ol><font size=\"-3\">Upgrade NOW to Space Parts & Space Vendors PLUS for full remote order control and inventory management."
