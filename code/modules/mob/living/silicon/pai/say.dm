/mob/living/silicon/pai/say(msg)
	if(silence_time)
		src.text2tab("<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(msg)

/mob/living/silicon/pai/binarycheck()
	return 0
