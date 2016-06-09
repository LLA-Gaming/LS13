/proc/DuplicateObject(obj/original, var/perfectcopy = 0 , var/sameloc = 0, var/atom/newloc = null, var/nerf = 0)
	if(!original)
		return null
	var/obj/O

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(newloc)

	if(perfectcopy && O && original)
		var/global/list/forbidden_vars = list("type","loc","locs","vars", "parent","parent_type", "verbs","ckey","key","power_supply","contents","reagents","stat","x","y","z","group")

		for(var/V in original.vars - forbidden_vars)
			if(istype(original.vars[V],/list))
				var/list/L = original.vars[V]
				O.vars[V] = L.Copy()
			else if(istype(original.vars[V],/datum))
				continue	// this would reference the original's object, that will break when it is used or deleted.
			else
				O.vars[V] = original.vars[V]

	if(istype(O))
		O.burn_state = FIRE_PROOF // holoitems do not burn
		if(nerf && istype(O,/obj/item))
			var/obj/item/I = O
			I.damtype = STAMINA // thou shalt not
		if(istype(O,/obj/machinery))
			var/obj/machinery/M = O
			M.power_change()
	O.update_icon()
	return O


/area/proc/copy_contents_to(var/area/A , var/platingRequired = 0, var/nerf_weapons = 0 )
	//Takes: Area. Optional: If it should copy to areas that don't have plating
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 99999
	var/src_min_y = 99999
	var/list/refined_src = new/list()

	for (var/turf/T in turfs_src)
		src_min_x = min(src_min_x,T.x)
		src_min_y = min(src_min_y,T.y)
	for (var/turf/T in turfs_src)
		refined_src[T] = "[T.x - src_min_x].[T.y - src_min_y]"

	var/trg_min_x = 99999
	var/trg_min_y = 99999
	var/list/refined_trg = new/list()

	for (var/turf/T in turfs_trg)
		trg_min_x = min(trg_min_x,T.x)
		trg_min_y = min(trg_min_y,T.y)
	for (var/turf/T in turfs_trg)
		refined_trg["[T.x - trg_min_x].[T.y - trg_min_y]"] = T

	var/list/toupdate = new/list()

	var/copiedobjs = list()

	for (var/turf/T in refined_src)
		//var/datum/coords/C_src = refined_src[T]
		var/coordstring = refined_src[T]
		var/turf/B = refined_trg[coordstring]
		if(!istype(B))
			continue

		if(platingRequired)
			if(istype(B, /turf/open/space))
				continue

		var/old_dir1 = T.dir
		var/old_icon_state1 = T.icon_state
		var/old_icon1 = T.icon

		var/turf/X = new T.type(B)
		X.dir = old_dir1
		X.icon = old_icon1
		X.icon_state = old_icon_state1

		for(var/obj/O in T)
			var/obj/O2 = DuplicateObject(O , 1, newloc = X, nerf=nerf_weapons)
			if(!O2) continue
			copiedobjs += O2.GetAllContents()

		for(var/mob/M in T)
			if(istype(M, /mob/camera)) continue // If we need to check for more mobs, I'll add a variable
			var/mob/SM = DuplicateObject(M , 1, newloc = X)
			copiedobjs += SM.GetAllContents()

		var/global/list/forbidden_vars = list("type","stat","loc","locs","vars", "parent", "parent_type","verbs","ckey","key","x","y","z","contents", "luminosity")
		for(var/V in T.vars - forbidden_vars)
			if(V == "air")
				var/turf/open/O1 = X
				var/turf/open/O2 = T
				O1.air.copy_from(O2.air)
				continue
			X.vars[V] = T.vars[V]
		toupdate += X

	if(toupdate.len)
		for(var/turf/T1 in toupdate)
			T1.CalculateAdjacentTurfs()
			SSair.add_to_active(T1,1)


	return copiedobjs

/datum/coords //Simple datum for storing coordinates.
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null

/area/proc/move_contents_to(var/area/A, var/turftoleave=null, var/direction = null)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	var/list/fromupdate = new/list()
	var/list/toupdate = new/list()

	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon

					var/turf/X = new T.type(B)
					X.dir = old_dir1
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi


					// Give the new turf our air, if simulated
					if(istype(X, /turf/open) && istype(T, /turf/open))
						var/turf/open/sim = X
						sim.copy_air_with_tile(T)

					/* Quick visual fix for some weird shuttle corner artefacts when on transit space tiles */
					if(direction && findtext(X.icon_state, "swall_s"))

						// Spawn a new shuttle corner object
						var/obj/corner = new()
						corner.loc = X
						corner.density = 1
						corner.anchored = 1
						corner.icon = X.icon
						corner.icon_state = replacetext(X.icon_state, "_s", "_f")
						corner.tag = "delete me"
						corner.name = "wall"

						// Find a new turf to take on the property of
						var/turf/nextturf = get_step(corner, direction)
						if(!nextturf || !istype(nextturf, /turf/open/space))
							nextturf = get_step(corner, turn(direction, 180))


						// Take on the icon of a neighboring scrolling space icon
						X.icon = nextturf.icon
						X.icon_state = nextturf.icon_state


					for(var/obj/O in T)

						// Reset the shuttle corners
						if(O.tag == "delete me")
							X.icon = 'icons/turf/shuttle.dmi'
							X.icon_state = replacetext(O.icon_state, "_f", "_s") // revert the turf to the old icon_state
							X.name = "wall"
							qdel(O) // prevents multiple shuttle corners from stacking
							continue
						if(!istype(O,/obj)) continue
						O.loc = X
					for(var/mob/M in T)
						if(!M.move_on_shuttle)
							continue
						M.loc = X

//					var/area/AR = X.loc

//					if(AR.dynamic_lighting)							//TODO: rewrite this code so it's not messed by lighting ~Carn
//						X.opacity = !X.opacity
//						X.set_opacity(!X.opacity)

					toupdate += X

					if(turftoleave)
						var/turf/ttl = new turftoleave(T)

//						var/area/AR2 = ttl.loc

//						if(AR2.dynamic_lighting)						//TODO: rewrite this code so it's not messed by lighting ~Carn
//							ttl.opacity = !ttl.opacity
//							ttl.sd_set_opacity(!ttl.opacity)

						fromupdate += ttl

					else
						T.ChangeTurf(/turf/open/space)

					refined_src -= T
					refined_trg -= B
					continue moving
