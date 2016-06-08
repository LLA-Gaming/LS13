/obj/item/device/tablet/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
									datum/tgui/master_ui = null, datum/ui_state/state = hands_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "tablet", name, 500, 500, master_ui, state)
		ui.open()

/obj/item/device/tablet/ui_data()
	var/list/data = list()
	data["test"] = flush
	return data

/obj/item/device/tablet/ui_act(action,params)
	if(..())
		return
	switch(action)
		if("test")
			return