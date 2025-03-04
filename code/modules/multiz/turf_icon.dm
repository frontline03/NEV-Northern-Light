/turf
	var/_initialized_transparency = FALSE //used only for roundstard update_icon
	var/isTransparent = FALSE

	var/image/DARKOVER = null

/turf/simulated/open
	isTransparent = TRUE

/turf/space
	isTransparent = TRUE

/turf/simulated/open/on_update_icon(var/update_neighbors, var/roundstart_update = FALSE)
	if (SSticker.current_state != GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = GetBelow(src)
		if (testBelow && testBelow.isTransparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	var/turf/below = GetBelow(src)
	if (!below || istype(below, /turf/space))
		ChangeTurf(/turf/space)
		return

	vis_contents.Cut()
	if (below)
		vis_contents.Add(below)

	updateFallability()

	_initialized_transparency = TRUE
	update_openspace() //propagate update upwards

/turf/space/on_update_icon(var/update_neighbors, var/roundstart_update = FALSE)
	if (SSticker.current_state < GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = GetBelow(src)
		if (testBelow && testBelow.isTransparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	cut_overlays()
	var/turf/below = GetBelow(src)
	if (istype(below, /turf/simulated/open))
		ChangeTurf(/turf/simulated/open)
		return

	vis_contents.Cut()
	if (below)
		vis_contents.Add(below)

	_initialized_transparency = TRUE
	update_openspace()

/hook/roundstart/proc/init_openspace()
//	var/counter = 0 //Eclipse edit - turf count is so huge the game thinks this proc is an infinite loop
	for (var/turf/T in turfs)
		if (T.isTransparent)
			T.update_icon(null, TRUE)
//		if(counter % 250 == 0)//Eclipse edit
//			CHECK_TICK
	return TRUE

/atom/proc/update_openspace()
	var/turf/T = GetAbove(src)
	if (T && T.isTransparent)
		T.update_icon()

/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()

/turf/Exited(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()
