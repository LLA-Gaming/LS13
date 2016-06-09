/datum/program/powermonitor
	name = "Power Monitor"
	app_id = "powermonitor"
	var/obj/machinery/computer/monitor/powmonitor = null // Power Monitor
	var/list/powermonitors = list()
	var/mode = 1

	use_app()
		dat = "<h4>Power Monitors - Please select one</h4><BR>"
		powmonitor = null
		powermonitors = list()
		var/powercount = 0



		for(var/obj/machinery/computer/monitor/pMon in machines)
			if(!(pMon.stat & (NOPOWER|BROKEN)) )
				powercount++
				powermonitors += pMon


		if(!powercount)
			dat += "<span class='danger'>No connection<BR></span>"
		else

			dat += "<FONT SIZE=-1>"
			var/count = 0
			for(var/obj/machinery/computer/monitor/pMon in powermonitors)
				count++
				dat += "<a href='byond://?src=\ref[src];choice=Power Select;target=[count]'>[pMon] </a><BR>"

			dat += "</FONT>"

	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Power Select")
				var/pnum = text2num(href_list["target"])
				powmonitor = powermonitors[pnum]

		tablet.attack_self()