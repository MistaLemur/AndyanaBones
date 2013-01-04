mob
	puzzles
		var/mob/puzzles/linked_to
		var/mob/puzzles/linked_to2
		var/state = 0
		lheight = 30
		doors

			action() return 0
			set_state() return 0
			gravity() return 0

			puzzle_1
				icon = 'Door.dmi'
				icon_state = "Wooden"
				pwidth = 8
				pheight = 96
				density = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/plates/puzzle_1/p in world) linked_to = p

			puzzle_2
				icon = 'Door.dmi'
				icon_state = "Wooden"
				pwidth = 8
				pheight = 96
				density = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/plates/puzzle_2/p in world) linked_to = p

				movement() if(state) pixel_move(0,2)

			puzzle_3
				icon = 'Door.dmi'
				icon_state = "Wooden"
				pwidth = 8
				pheight = 96
				density = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/plates/puzzle_3/p in world) linked_to = p

				movement() if(state) pixel_move(0,2)

			puzzle_4
				icon = 'Door.dmi'
				icon_state = "Wooden"
				pwidth = 8
				pheight = 96
				density = 1
				New()
					..()
					spawn(10)
						for(var/mob/puzzles/plates/puzzle_4a/p in world) linked_to = p
						for(var/mob/puzzles/plates/puzzle_4b/p in world) linked_to2 = p

				movement() if(state == 2) pixel_move(0,2)






		plates
			/*
				Push a block on a switch, switch goes down, door goes up. Fun fun.
			*/

			puzzle_1
				icon = 'Plates.dmi'
				icon_state = "Plate"
				pwidth = 32
				density = 0
				pheight = 0
				pixel_y = -16
				scaffold = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/doors/puzzle_1/d in world) linked_to = d

				set_state() return 0

				action() for(var/mob/m in top()) linked_to.pixel_move(0, 2)




			puzzle_2
				/*
					Just push the switch.
				*/
				icon = 'Plates.dmi'
				icon_state = "Plate"
				pwidth = 32
				density = 0
				pheight = 0
				pixel_y = -16
				scaffold = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/doors/puzzle_2/d in world) linked_to = d

				set_state() return 0

				action()
					if(state) return 0
					else
						for(var/mob/m in top())
							state = 1
							linked_to.state = 1

			puzzle_3
				icon = 'Plates.dmi'
				icon_state = "Plate"
				pwidth = 32
				density = 0
				pheight = 0
				pixel_y = -16
				scaffold = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/doors/puzzle_3/d in world) linked_to = d

				set_state() return 0

				action() for(var/mob/m in top()) linked_to.pixel_move(0, 2)

			puzzle_4a
				icon = 'Plates.dmi'
				icon_state = "Plate"
				pwidth = 32
				density = 0
				pheight = 0
				pixel_y = -16
				scaffold = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/doors/puzzle_4/d in world) linked_to = d

				set_state() return 0

				action()
					if(state) ..()
					else
						for(var/mob/m in top())
							state = 1
							linked_to.state++
			puzzle_4b
				icon = 'Plates.dmi'
				icon_state = "Plate"
				pwidth = 32
				density = 0
				pheight = 0
				pixel_y = -16
				scaffold = 1
				New()
					..()
					spawn(10) for(var/mob/puzzles/doors/puzzle_4/d in world) linked_to = d

				set_state() return 0

				action()
					if(state) ..()
					else
						for(var/mob/m in top())
							state = 1
							linked_to.state++




