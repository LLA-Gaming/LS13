/image/master_plane
	name = "Master Plane"
	appearance_flags = NO_CLIENT_COLOR | PLANE_MASTER | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	mouse_opacity = 0
	plane = MASTERPLANE
	blend_mode = BLEND_MULTIPLY
	color = list(null,null,null,"#0000","#000f")

/image/hud_plane
	name = "HUD Plane"
	appearance_flags = NO_CLIENT_COLOR | PLANE_MASTER | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	mouse_opacity = 0
	plane = HUDPLANE

/image/darkness_plane
	plane = DARKNESSPLANE
	blend_mode = BLEND_ADD
	mouse_opacity = 0
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	New()
		..()
		var/matrix/m = matrix()
		m.Scale(world.view*2.2)
		transform = m

/mob
	var/image/darkness_plane/darkness_plane
	var/image/master_plane/master_plane
	var/image/hud_plane/hud_plane

	proc/grant_planes()
		if(!client) return

		if(!master_plane)
			master_plane = new(loc=src)
		if(!hud_plane)
			hud_plane = new/image/hud_plane(loc=src)
		if(!darkness_plane)
			darkness_plane = new/image/darkness_plane(loc=src)

		src << master_plane
		src << hud_plane
		src << darkness_plane

		if(see_invisible == SEE_INVISIBLE_NOLIGHTING)
			darkness_plane.alpha = 255
		else
			darkness_plane.alpha = 0