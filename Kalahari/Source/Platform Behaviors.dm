mob

	platforms

		density = 1
		scaffold = 1

		stone_32_x120y0
			icon = 'StonePlatform.dmi'
			icon_state = ""
			range_px = 120

		/*
		stone_32_r180
			icon = 'StonePlatform.dmi'
			icon_state = ""
			density = 1
			range_px = 180
		*/

		stone_32_x0y120
			icon = 'StonePlatform.dmi'
			icon_state = ""
			range_px = 0
			range_py = 120


		pwidth = 32
		pheight = 12

		lheight = 12

		dir = RIGHT //Basic Horizontal

		var
			start_px
			range_px
			end_px

			start_py
			range_py
			end_py

			direction = 1

			vx
			vy
			velMagnitude = 2

			percentTravelled = 0

			riders[]

		New()
			..()

			set_pos(px, py) //+16? Why? BECAUSE I FUCKING SAID SO. nigga wigga
			set_range()

		proc
			set_range()
				start_px = px
				end_px = px + range_px

				start_py = py
				end_py = py + range_py

				var/d = sqrt(range_px * range_px + range_py * range_py)
				vx = velMagnitude * range_px / d
				vy = velMagnitude * range_py / d


			compute_travelled()
				var/dx, dy
				dx = px - start_px
				dy = py - start_py

				var/cd = sqrt(dx*dx+dy*dy)

				var/d = sqrt(range_px * range_px + range_py * range_py)
				return (cd/d)


		movement()
			/*
			// move right
			if(dir == RIGHT)
				pixel_move(2,0)

				// When we reach end_px, start moving the other way
				if(px >= end_px)
					dir = LEFT
			*/

			pixel_move(vx * direction, vy * direction)

			//world<<percentTravelled

			if(percentTravelled >= 1)
				direction *= -1
			if(percentTravelled <= 0)
				direction *= -1


		pixel_move(dpx, dpy)

			riders = top(2)
			for(var/mob/m in riders)
				if(istype(m,/mob/platforms)) continue
				//world<<"There's a rider! [m]"
				m.set_pos(dpx+m.px, dpy+m.py)

			. = ..()


			percentTravelled = compute_travelled()
			//world<<percentTravelled

			updateLayer()



		bump(mob/m, d)
			// if the platform bumped into a mob, try to move that mob out of the way

			riders = top(2)

			if(istype(m) && !(m in riders))
				/*
				if(d == DOWN)
					/*keep note. This is part where'd we want to crush ANDY. */
					//Deal damage to andy if andy is sandwiched.
					//Call bottom() on Andy, and if there is another dense object then damage andy.

				*/

				//Attempt to push andy now and try moving again
				/*
				if(m.pixel_move(vx * direction , 0) && m.pixel_move(0 , vy * direction))
					// try making the platform move again
					pixel_move(vx * direction, vy * direction)
				*/

				if(d == UP || d == DOWN)
					if(m.pixel_move(0,vy * direction))
						// try making the platform move again
						pixel_move(0, vy * direction)
					else
						//ouch nigga

				if(d == LEFT || d == RIGHT)
					if(m.pixel_move(vx * direction,0))
						// try making the platform move again
						pixel_move( vx * direction,0)

				if(percentTravelled >=1)
					direction *= -1
				if(percentTravelled <= 0)
					direction *= -1


		Level_1
			stone_64_x320y0
				icon = 'StonePlatform.dmi'
				icon_state = "64"
				range_px = 240
				pwidth = 64

			stone_64_x0y320
				icon = 'StonePlatform.dmi'
				icon_state = "64"
				range_px = 0

				start_py = 1
				range_py = 240

				pwidth = 64
