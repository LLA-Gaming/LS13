/datum/program/atmosscan
	name = "Atmospherics Scan"
	app_id = "atmosphericsscan"
	utility = 1
	drm = 1

	use_app()
		dat = "<h4>Atmospheric Readings</h4>"

		var/turf/T = usr.loc
		if (isnull(T))
			dat += "Unable to obtain a reading.<br>"
		else
			var/datum/gas_mixture/environment = T.return_air()
			var/list/env_gases = environment.gases

			var/pressure = environment.return_pressure()
			var/total_moles = environment.total_moles()

			dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

			if (total_moles)
				for(var/id in env_gases)
					var/gas_level = env_gases[id][MOLES]/total_moles
					if(gas_level > 0)
						dat += "[env_gases[id][GAS_META][META_GAS_NAME]]: [round(gas_level*100, 0.01)]%<br>"

			dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
		dat += "<br>"