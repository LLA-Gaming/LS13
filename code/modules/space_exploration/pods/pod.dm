var/list/pod_list = list()

/obj/pod
	name = "Pod"
	icon = 'icons/obj/pod-1-1.dmi'
	icon_state = "miniputt"
	density = 1
	anchored = 1
	layer = 3.2
	unacidable = 1

	var/list/size = list(1, 1)
	var/obj/machinery/portable_atmospherics/canister/internal_canister
	var/datum/gas_mixture/internal_air
	var/obj/item/weapon/stock_parts/cell/power_source
	var/inertial_direction = NORTH
	var/turn_direction = NORTH
	var/last_move_time = 0
	var/move_cooldown = 2
	var/enter_delay = 10
	var/exit_delay = 10
	var/list/locks = list() // DNA (unique_enzymes) or code lock.
	var/lumens = 6
	var/toggles = 0
	var/seats = 0 // Amount of additional people that can fit into the pod (excludes pilot)
	var/being_repaired = 0
	var/emagged = 0
	var/last_fire_tick = 0
	var/last_notice_tick = 0
	var/inertial_drift_delay = 0

	var/list/hardpoints = list()
	var/list/attachments = list()

	var/mob/living/carbon/human/pilot = 0

	var/datum/effect_system/spark_spread/sparks

	var/datum/pod_log/pod_log

	New()
		..()

		if(!size || !size.len)
			qdel(src)
			return

		pod_list += src
		SSobj.processing |= src

		bound_width = size[1] * 32
		bound_height = size[2] * 32

		internal_canister = GetCanister()
		internal_air = GetEnvironment()
		hardpoints = GetHardpoints()
		power_source = GetPowercell()
		attachments = (GetAdditionalAttachments() + GetArmor() + GetEngine())
		seats = GetSeats()
		pod_log = new(src)

		max_health = initial(health)

		sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(5, 0, src)
		sparks.attach(src)

		if(fexists("icons/obj/pod-[size[1]]-[size[2]].dmi"))
			icon = file("icons/obj/pod-[size[1]]-[size[2]].dmi")

		// Place attachments / batteries under the pod and they'll get attached (map editor)
		spawn(10)
			for(var/turf/T in GetTurfsUnderPod())
				for(var/obj/item/weapon/pod_attachment/P in T)
					if(CanAttach(P))
						P.OnAttach(src, 0)

				var/obj/item/weapon/stock_parts/cell/cell = locate() in T
				if(cell)
					qdel(power_source)
					cell.loc = src
					power_source = cell




	process()
		/*
		* Damage Handling
		*/

		if(health <= 0)
			DestroyPod()
			return 0

		health = Clamp(health, 0, max_health)

		var/health_percent = HealthPercent()
		if(health_percent <= pod_config.damage_overlay_threshold)
			if(!HasDamageFlag(P_DAMAGE_GENERAL))
				AddDamageFlag(P_DAMAGE_GENERAL)
		else
			if(HasDamageFlag(P_DAMAGE_GENERAL))
				RemoveDamageFlag(P_DAMAGE_GENERAL)

		if(HasDamageFlag(P_DAMAGE_FIRE) && ((last_fire_tick + pod_config.fire_damage_cooldown) <= world.time))
			// If we are in space, the fire consumes a bit of oxygen from the internal air (which is refilled by the gas canister in the pod)
			if(istype(get_turf(src), /turf/open/space))
				if(!internal_air || internal_air.gases["o2"][MOLES] < pod_config.fire_damage_oxygen_cutoff)
					RemoveDamageFlag(P_DAMAGE_FIRE)

				internal_air.gases["o2"][MOLES] = (internal_air.gases["o2"][MOLES] - (internal_air.gases["o2"][MOLES] * pod_config.fire_oxygen_consumption_percent))

			TakeDamage(pod_config.fire_damage)
			last_fire_tick = world.time

		if(HasDamageFlag(P_DAMAGE_EMPED))
			if((emped_at + emped_duration) <= world.time)
				RemoveDamageFlag(P_DAMAGE_EMPED)
			else
				if(prob(pod_config.emp_sparkchance))
					sparks.start()

		for(var/obj/effect/hotspot/H in GetTurfsUnderPod())
			var/show_notice = ((last_notice_tick + pod_config.damage_notice_cooldown) <= world.time)
			fire_act(0, H.temperature, H.volume, show_notice)

		/*
		* Inertial Drift
		*/

		if(size[1] > 1)
			// So for some reason when going north or east, Entered() isn't called on the turfs in a 2x2 pod
			for(var/turf/open/space/space in GetTurfsUnderPod())
				space.Entered(src)

		if(!inertial_direction)
			return 0

		if(!HasTraction())
			step(src, inertial_direction)
			spawn(-1)
				dir = turn_direction

		/*
		* Equalize Air
		*/

		if(internal_canister)
			var/datum/gas_mixture/tank_air = internal_canister.return_air()

			if(!internal_air || !tank_air)
				return 0

			var/release_pressure = ONE_ATMOSPHERE
			var/cabin_pressure = internal_air.return_pressure()
			var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
			var/transfer_moles = 0
			if(pressure_delta > 0) //cabin pressure lower than release pressure
				if(tank_air.return_temperature() > 0)
					transfer_moles = pressure_delta*internal_air.return_volume()/(internal_air.return_temperature() * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
					internal_air.merge(removed)
			else if(pressure_delta < 0) //cabin pressure higher than release pressure
				var/datum/gas_mixture/t_air = return_air()
				pressure_delta = cabin_pressure - release_pressure
				if(t_air)
					pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
				if(pressure_delta > 0) //if location pressure is lower than cabin pressure
					transfer_moles = pressure_delta*internal_air.return_volume()/(internal_air.return_temperature() * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = internal_air.remove(transfer_moles)
					if(t_air)
						t_air.merge(removed)
					else //just delete the cabin gas, we're in space or some shit
						qdel(removed)

		/*
		* Attachments
		*/

		for(var/obj/item/weapon/pod_attachment/A in attachments)
			A.PodProcess(src)

		var/obj/item/weapon/pod_attachment/engine/E = GetAttachmentOnHardpoint(P_HARDPOINT_ENGINE)
		if(E)
			move_cooldown = Clamp((initial(move_cooldown) + E.pod_move_reduction), 0.1, 5)
			inertial_drift_delay = initial(inertial_drift_delay) + E.pod_move_reduction
		else
			move_cooldown = initial(move_cooldown)
			inertial_drift_delay = initial(inertial_drift_delay)

		if(toggles & P_TOGGLE_LIGHTS)
			SetLuminosity(lumens)
		else
			SetLuminosity(0)

	Del()
		DestroyPod()
		..()

	examine()
		..()
		var/hp = HealthPercent()
		switch(hp)
			if(-INFINITY to 25)
				usr.text2tab("<span class='warning'>It looks severely damaged.</span>")
			if(26 to 50)
				usr.text2tab("<span class='warning'>It looks significantly damaged.</span>")
			if(51 to 75)
				usr.text2tab("<span class='warning'>It looks moderately damaged.</span>")
			if(76 to 99)
				usr.text2tab("<span class='warning'>It looks slightly damaged.</span>")
			if(100 to INFINITY)
				usr.text2tab("<span class='info'>It looks undamaged.</span>")

		usr.text2tab("<span class='info'>Attached are:</span>")
		for(var/obj/item/weapon/pod_attachment/attachment in GetAttachments())
			if(attachment.hardpoint_slot in list(P_HARDPOINT_PRIMARY_ATTACHMENT, P_HARDPOINT_ARMOR, P_HARDPOINT_SHIELD, P_HARDPOINT_SECONDARY_ATTACHMENT))
				usr.text2tab("<span class='info'>- \The [attachment.name]")

	update_icon()
		overlays.Cut()

		for(var/obj/item/weapon/pod_attachment/A in attachments)
			var/image/overlay = A.GetOverlay(size)
			if(!overlay)	continue
			overlays += overlay

		if(HasDamageFlag(P_DAMAGE_GENERAL))
			overlays += image(icon = "icons/obj/pod-[size[1]]-[size[2]].dmi", icon_state = "pod_damage")

		if(HasDamageFlag(P_DAMAGE_FIRE))
			overlays += image(icon = "icons/obj/pod-[size[1]]-[size[2]].dmi", icon_state = "pod_fire")

	proc/HandleExit(var/mob/living/carbon/human/H)
		if(toggles & P_TOGGLE_HUDLOCK)
			if(alert(H, "Outside HUD Access is diabled, are you sure you want to exit?", "Confirmation", "Yes", "No") == "No")
				return 0

		var/as_pilot = (H == pilot)

		H.text2tab("<span class='info'>You start leaving the [src]..<span>")
		if(do_after(H, exit_delay))
			H.text2tab("<span class='info'>You leave the [src].</span>")
			H.loc = get_turf(src)
			if(as_pilot)
				pilot = 0

		pod_log.LogOccupancy(H, as_pilot)

	proc/HandleEnter(var/mob/living/carbon/human/H, var/mob/living/carbon/human/dragged_by)
		if(!CanOpenPod(H))
			return 0

		var/as_passenger = 0
		if(dragged_by)
			as_passenger = 1
		else
			if(pilot)
				if(HasOpenSeat())
					var/enter_anyways = input("The [src] is already manned. Do you want to enter as a passenger?") in list("Yes", "No")
					if(enter_anyways == "Yes")
						as_passenger = 1
					else
						return 0
				else
					H.text2tab("<span class='warning'>The [src] is already manned[seats ? " and all the seats are occupied" : ""].")
					return 0

		if(!dragged_by)
			H.text2tab("<span class='info'>You start to enter \the [src]..</span>")
		else
			H.text2tab("<span class='warning'>You are being put into \the [src] by [dragged_by.name]...</span>")
			dragged_by.text2tab("<span class='info'>You start to put [H] into \the [src].</span>")

		if(do_after(H, enter_delay))
			if(!HasOpenSeat())
				if(!dragged_by)
					H.text2tab("<span class='warning'>\The [src] is already manned[seats ? " and all the seats are occupied" : ""].")
				else
					dragged_by.text2tab("<span class='warning'>\The [src] is full.</span>")
				return 0

			if(!dragged_by)
				H.text2tab("<span class='info'>You enter the [src].</span>")
			else
				H.text2tab("<span class='warning'>You are placed into \the [src] by [dragged_by.name].</span>")
				dragged_by.text2tab("<span class='info'>You place [H.name] into \the [src].</span>")

			H.loc = src
			if(!as_passenger)
				pilot = H
				PrintSystemNotice("Systems initialized.")
				if(power_source)
					PrintSystemNotice("Power Charge: [power_source.charge]/[power_source.maxcharge] ([power_source.percent()]%)")
				else
					PrintSystemAlert("No power source installed.")
				PrintSystemNotice("Integrity: [round((health / max_health) * 100)]%.")

		pod_log.LogOccupancy(H, !as_passenger, dragged_by)

	MouseDrop_T(var/atom/movable/dropping, var/mob/living/user)
		if(istype(dropping, /mob/living/carbon/human))
			if(dropping == user)
				HandleEnter(dropping)
			else
				HandleEnter(dropping, user)

		// Give attachments a chance to handle mouse drops.
		for(var/obj/item/weapon/pod_attachment/attachment in GetAttachments())
			if(attachment.PodHandleDropAction(dropping, user))
				return 0

	relaymove(var/mob/user, var/_dir)
		if(user == pilot)
			DoMove(user, _dir)

	proc/DoMove(var/mob/user, var/_dir)
		if(user != pilot)
			return 0

		var/obj/item/weapon/pod_attachment/engine/engine = GetAttachmentOnHardpoint(P_HARDPOINT_ENGINE)
		if(!engine)
			PrintSystemAlert("No engine attached.")
			return 0
		else if(engine.active & P_ATTACHMENT_INACTIVE)
			PrintSystemAlert("Engine is turned off.")
			return 0

		if(!HasPower(pod_config.movement_cost))
			PrintSystemAlert("Insufficient power.")
			return 0

		if(HasDamageFlag(P_DAMAGE_EMPED))
			_dir = pick(cardinal)

		var/can_drive_over = 0
		var/is_dense = 0
		for(var/turf/T in GetDirectionalTurfs(_dir))
			if(T.density)
				is_dense = 1
			for(var/path in pod_config.drivable)
				if(istext(path))	path = text2path(path)
				if(istype(T, path) || istype(get_area(T), path) || (T.icon_state == "plating"))
					can_drive_over = 1
					break
				else
					if(istype(T, /turf/open/floor))
						var/turf/open/floor/F = T
						if(F.icon_state == F.icon_plating)
							can_drive_over = 1
							break

		// Bump() does not play nice with 64x64, so this will have to do.
		if(is_dense)
			dir = _dir
			var/list/turfs = GetDirectionalTurfs(dir)
			for(var/obj/item/weapon/pod_attachment/attachment in GetAttachments())
				attachment.PodBumpedAction(turfs)
			last_move_time = world.time
			return 0

		if(!can_drive_over)
			dir = _dir
			last_move_time = world.time
			return 0

		if(size[1] > 1)
			// So for some reason when going north or east, Entered() isn't called on the turfs in a 2x2 pod
			for(var/turf/open/space/space in GetTurfsUnderPod())
				space.Entered(src)

		if(istype(get_turf(src), /turf/open/space) && !HasTraction())
			if((_dir == turn(inertial_direction, 180)) && (toggles & P_TOGGLE_SOR))
				inertial_direction = 0
				return 1

			if(turn_direction == _dir)
				inertial_direction = _dir
			else
				dir = _dir
				turn_direction = _dir
		else
			if((last_move_time + move_cooldown) > world.time)
				return 0

			step(src, _dir)
			UsePower(pod_config.movement_cost)
			turn_direction = _dir
			inertial_direction = _dir

		last_move_time = world.time

	attack_hand(var/mob/living/user)
		if(user.a_intent == "grab")
			var/list/possible_targets = list()
			for(var/mob/living/M in GetOccupants())
				possible_targets["[M.name] ([(pilot && M == pilot) ? "Pilot" : "Passenger"])"] = M

			if(!length(possible_targets))
				return 0

			var/chosen = input(user, "Who do you want to pull out?", "Input") in possible_targets + "Cancel"
			if(!chosen || chosen == "Cancel")
				return 0

			var/mob/living/chosen_mob = possible_targets[chosen]
			if(!chosen_mob || (!(chosen_mob in GetOccupants())))
				return 0

			var/is_pilot = 0
			if(pilot && (pilot == chosen_mob))
				is_pilot = 1

			chosen_mob.text2tab("<span class='warning'>You are being pulled out of the pod by [user].</span>")
			user.text2tab("<span class='info'>You start to pull out [chosen_mob].</span>")
			if(do_after(user, pod_config.pod_pullout_delay))
				if(chosen_mob && (chosen_mob in GetOccupants()))
					chosen_mob.text2tab("<span class='warning'>You were pulled out of \the [src] from [user].</span>")
					pod_log.LogOccupancy(chosen_mob, 1, user)
					chosen_mob.loc = get_turf(src)
					if(is_pilot)
						pilot = 0
				else
					return 0
			else
				user.text2tab("<span class='info'>\The [src] is unmanned.</span>")

			return 1

		..()

	attackby(var/obj/item/I, var/mob/living/user)
		if(istype(I, /obj/item/weapon/pod_attachment))
			var/obj/item/weapon/pod_attachment/attachment = I

			var/can_attach_result = CanAttach(attachment)
			if(can_attach_result & P_ATTACH_ERROR_CLEAR)
				attachment.StartAttach(src, user)
			else
				switch(can_attach_result)
					if(P_ATTACH_ERROR_TOOBIG)
						user.text2tab("<span class='warning'>The [src] is too small for the [I].</span>")
					if(P_ATTACH_ERROR_ALREADY_ATTACHED)
						user.text2tab("<span class='warning'>There is already an attachment on that slot.</span>")
				return 0
			return 1

		if(user.a_intent == "harm")
			goto Damage

		if(istype(I, /obj/item/weapon/stock_parts/cell))
			if(power_source)
				user.text2tab("<span class='warning'>There is already a cell installed.</span>")
				return 0
			else
				user.text2tab("<span class='notice'>You start to install \the [I] into \the [src].</span>")
				if(do_after(user, 20))
					user.unEquip(I, 1)
					I.loc = src
					power_source = I
					user.text2tab("<span class='notice'>You install \the [I] into \the [src].</span>")
			return 0

		if(istype(I, /obj/item/device/multitool))
			if(CanOpenPod(user))
				OpenHUD(user)

			return 1

		if(istype(I, /obj/item/stack/sheet/metal))
			if(being_repaired)
				return 0

			if(HealthPercent() > pod_config.metal_repair_threshold_percent)
				user.text2tab("<span class='warning'>\The [src] doesn't require any more metal.</span>")
				return 0

			var/obj/item/stack/sheet/metal/M = I

			being_repaired = 1

			user.text2tab("<span class='info'>You start to add metal to \the [src].</span>")
			while(do_after(user, 30) && M && M.amount)
				user.text2tab("<span class='info'>You add some metal to \the [src].</span>")
				health += pod_config.metal_repair_amount
				update_icon()
				M.use(1)
				if(HealthPercent() > pod_config.metal_repair_threshold_percent)
					user.text2tab("<span class='warning'>\The [src] doesn't require any more metal.</span>")
					break

			being_repaired = 0

			user.text2tab("<span class='info'>You stop repairing \the [src].</span>")

			return 0

		if(istype(I, /obj/item/weapon/weldingtool))
			if(being_repaired)
				return 0

			if(HealthPercent() < pod_config.metal_repair_threshold_percent)
				user.text2tab("<span class='warning'>\The [src] is too damaged to repair without additional metal.</span>")
				return 0

			if(HealthPercent() >= 100)
				user.text2tab("<span class='info'>\The [src] is already fully repaired.</span>")
				return 0

			var/obj/item/weapon/weldingtool/W = I

			being_repaired = 1

			user.text2tab("<span class='info'>You start to repair some damage on \the [src].</span>")
			while(do_after(user, 30) && W.isOn())
				user.text2tab("<span class='info'>You repair some damage.</span>")
				health += pod_config.welding_repair_amount
				update_icon()
				W.remove_fuel(1, user)
				if(HealthPercent() >= 100)
					user.text2tab("<span class='info'>\The [src] is now fully repaired.</span>")
					break

			being_repaired = 0

			user.text2tab("<span class='info'>You stop repairing \the [src].</span>")

			return 0

		if(istype(I, /obj/item/weapon/pen))
			var/new_name = input(user, "Please enter a new name for the pod.", "Input") as text
			new_name = strip_html(new_name)
			new_name = trim(new_name)

			user.text2tab("<span class='info'>You change the [name]'s name to [new_name].</span>")
			name = "\"[new_name]\""
			return 0

		if(istype(I, /obj/item/weapon/card/emag))
			if(emagged)
				return 0

			sparks.start()
			user.text2tab("<span class='notice'>You emag \the [src].</span>")

			emagged = 1

			return 0

		// Give attachments a chance to handle attackby.
		for(var/obj/item/weapon/pod_attachment/attachment in GetAttachments())
			if(attachment.PodAttackbyAction(I, user))
				return 0

		Damage

		if(I.force)
			user.text2tab("<span class='attack'>You hit \the [src] with the [I].</span>")
			TakeDamage(I.force, 0, I, user)
			add_logs(user, (pilot ? pilot : 0), "attacked a space pod", 1, I, " (REMHP: [health])")
			user.changeNext_move(8)

		update_icon()

	proc/OnClick(var/atom/A, var/mob/M, var/list/modifiers = list())
		var/click_type = GetClickTypeFromList(modifiers)

		if(click_type == P_ATTACHMENT_KEYBIND_SHIFT)
			A.examine()

		if(click_type == P_ATTACHMENT_KEYBIND_CTRL)
			if(istype(A, /obj/machinery/portable_atmospherics/canister) && A in bounds(1))
				var/obj/machinery/portable_atmospherics/canister/canister = A
				if(internal_canister)
					M.text2tab("<span class='notice'>There already is a gas canister installed.</span>")
					return 0
				M.text2tab("<span class='info'>\The [src] starts to load \the [canister].</span>")
				sleep(30)
				if(src && (canister in bounds(1)) && !internal_canister)
					canister.loc = src
					internal_canister = canister
					M.text2tab("<span class='info'>\The [src] loaded \the [canister].</span>")

		if(!pilot || M != pilot)
			return 0

		for(var/obj/item/weapon/pod_attachment/attachment in attachments)
			if(attachment.keybind)
				if(attachment.keybind == click_type)
					attachment.Use(A, M)

		M.changeNext_move(3)

	Bumped(var/atom/movable/AM)
		if(istype(AM, /obj/effect/particle_effect/water))
			if(HasDamageFlag(P_DAMAGE_FIRE))
				RemoveDamageFlag(P_DAMAGE_FIRE)
				PrintSystemNotice("Fire extinguished.")
		..()

	CtrlShiftClick(var/mob/user)
		if(!check_rights(R_SECONDARYADMIN))
			return ..()

		if(user.client)
			user.client.debug_variables(pod_log)

		OpenDebugMenu(user)

	Adjacent(var/atom/neighbor)
		if(neighbor in bounds(1))
			return 1

	return_air()
		if(toggles & P_TOGGLE_ENVAIR)
			return loc.return_air()
		if(internal_air)
			return internal_air
		else	..()


	remove_air(var/amt)
		if(toggles & P_TOGGLE_ENVAIR)
			var/datum/gas_mixture/env = loc.return_air()
			return env.remove(amt)
		if(internal_air)
			return internal_air.remove(amt)
		else return ..()

	proc/return_temperature()
		if(toggles & P_TOGGLE_ENVAIR)
			var/datum/gas_mixture/env = loc.return_air()
			return env.return_temperature()
		if(internal_air)
			return internal_air.return_temperature()
		else return ..()

	proc/return_pressure()
		if(toggles & P_TOGGLE_ENVAIR)
			var/datum/gas_mixture/env = loc.return_air()
			return env.return_pressure()
		if(internal_air)
			return internal_air.return_pressure()
		else return ..()