obj
	onScreen/mapText
		layer = 99999
		mptext
			icon = 'Skull.dmi'
			icon_state = "Skully"
			maptext_height = 100
			maptext_width = 800
			pixel_x = -64
			layer = 99999
			var
				lasttext = ""
			New(client/C, x,xp,y,yp)
				src.screen_loc = "[x]:[xp],[y]:[yp]"
				C.screen += src
			proc
				update(text, length)
					layer = 99999
					invisibility = 0
					//maptext = "[text]"
					maptext = "<font face = \"garamond\"> [text]"
					lasttext = text
					spawn(length*world.tick_lag)
						maptext = null
						invisibility = 1