/datum/program/sadtrombone
	name = "Sad Trombone"
	app_id = "sadtrombone"
	price = 20
	var/last_honk = null

	use_app()
		if ( !(last_honk && world.time < last_honk + 20) )
			playsound(tablet.loc, 'sound/misc/sadtrombone.ogg', 50, 1)
			last_honk = world.time