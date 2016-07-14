/image/master_plane
	name = "Master Plane"
	appearance_flags = NO_CLIENT_COLOR | PLANE_MASTER | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	mouse_opacity = 0
	plane = MASTERPLANE

/image/hud_plane
	name = "HUD Plane"
	appearance_flags = NO_CLIENT_COLOR | PLANE_MASTER | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	mouse_opacity = 0
	plane = HUDPLANE


/mob
	var/list/planes = list()

	proc/grant_plane(var/plane_type)
		if(!client) return

		var/add_to_planes = 1
		var/add_to_client = 1
		var/image/newplane

		for(var/image/plane in planes)
			if(istype(plane,plane_type))
				add_to_planes = 0
				newplane = plane

		if(add_to_planes)
			newplane = new plane_type(src)
			planes.Add(newplane)

		for(var/image/plane in client.images)
			if(istype(plane,plane_type))
				add_to_client = 0

		if(add_to_client)
			client.images += newplane

	proc/take_plane(var/plane_type)
		if(!client) return

		for(var/image/plane in client.images)
			if(istype(plane,plane_type))
				client.images -= plane

		for(var/image/plane in planes)
			if(istype(plane,plane_type))
				planes.Remove(plane)