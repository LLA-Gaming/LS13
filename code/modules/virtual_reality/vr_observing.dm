/mob/camera/virtual_observer/Move(NewLoc, Dir = 0)
	var/area/A = get_area(NewLoc)
	if(istype(A, /area/virtual/vr_dome) || istype(A, /area/virtual/vr_dome_ghost))
		loc = NewLoc
		return 1