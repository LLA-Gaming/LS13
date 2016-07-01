/datum/program/signaller
	name = "Remote Signaling System"
	app_id = "remotesignalingsystem"
	var/obj/item/radio/integrated/signal/radio

	use_app()
		if(!radio)
			radio = new(tablet)
		dat = "<h4>Remote Signaling System</h4>"

		dat += {"
		<a href='byond://?src=\ref[src];choice=Send Signal'>Send Signal</A><BR>
		Frequency:
		<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=-10'>-</a>
		<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=-2'>-</a>
		[format_frequency(radio.frequency)]
		<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=2'>+</a>
		<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=10'>+</a><br>
		<br>
		Code:
		<a href='byond://?src=\ref[src];choice=Signal Code;scode=-5'>-</a>
		<a href='byond://?src=\ref[src];choice=Signal Code;scode=-1'>-</a>
		[radio.code]
		<a href='byond://?src=\ref[src];choice=Signal Code;scode=1'>+</a>
		<a href='byond://?src=\ref[src];choice=Signal Code;scode=5'>+</a><br>"}

	Topic(href, href_list)

		if (!..()) return
		switch(href_list["choice"])//Now we switch based on choice.
			if("Send Signal")
				spawn( 0 )
					var/obj/item/radio/integrated/signal/S = radio
					S.send_signal("ACTIVATE")
					return

			if("Signal Frequency")
				var/obj/item/radio/integrated/signal/S = radio
				var/new_frequency = sanitize_frequency(S.frequency + text2num(href_list["sfreq"]))
				S.set_frequency(new_frequency)

		tablet.attack_self(usr)