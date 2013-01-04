
world
	mob = /mob/actor/player

mob
	//lheight = 3

	activeBool = 1

	var/on_platform = 0

	actor//Since in our case, mob is every object that can move and is affected by sidescroller physics...

		// acceleration and deceleration rates
		accel = 1
		decel = 1
		gravity = 0.8

		move_speed = 5
		climb_speed = 5
		jump_speed = 10
		fall_speed = 20

		var
			tmp/health
			maxHealth

			tmp/dead

			tmp/frame
			tmp/frameTimer
			tmp/invincibleTimer

			tmp/turf/spawnLoc

		proc
			Damage(damage,mob/actor/source)
				if(time < invincibleTimer) return 0
				if(source == src) return 0

				health = max(0, health - damage)
				. = 1

				//update health shit here if necesasry
				HealthUpdate()

				if(health <=0)
					Death()

			Death()
				if(health > 0) return 0
				if(dead) return 0
				dead = 1

				//Update shit here.
				DeathUpdate()

			HealthUpdate() //This is for player subclass to override to update interface

			DeathUpdate() //that sort of thing

			Spawn(turf/nloc)


		enemy

		player
			lheight = 60

			name = "Andyana Bones"
			pwidth = 24
			pheight = 50

			icon = 'Torso.dmi'
			pixel_x = -36
			pixel_y = -3

			move_speed = 7
			climb_speed = 5
			jump_speed = 10
			fall_speed = 40


			//maximum speed is 26 pixels per 3 frames.
			//~8 pixels per frame.
			//at 10 fps, this works out to 87 pixels per second
			//at 20 fps, this works out to 173 pixels per second
			//at 25 fps, this works out to 217 pixels per second
			//at 30 fps, this works out to 260 pixels per second

			var
				image/over = new('Arms.dmi')
				image/under = new('Arms.dmi')

				obj/onScreen/mapText/mptext/mptext

				atom/checkPoint

				flicker

				Background
					back1
					back2
					back3
					back4
					back5
					fore1

				tmp/water
				maxWater = 20

				whipTimer

			maxHealth = 30

			Login()
				if(loaded) winset(src,"default.child1","left=titleScreen")
				.=..()
				over.loc = src
				under.loc = src

				client.images.Add(over,under)

				camera.mode = camera.FOLLOW
				camera.lag = 0

				set_state()
				updateLayer()

				Andy = src

			DeathUpdate()
				UpdateHealth()

				density = 0
				src<<sound('ManDeath2.wav')

				score = round(score/2)
				UpdatePoints()


				//Freeze and clear inputs
				client.clear_input()
				client.lock_input()
				freezeControls = 1

				spawn(40)
					//spawn thread for a short while
					Spawn(spawnLoc)

			Spawn(turf/nloc)
				//Unfreeze and clear inputs
				/*
				world << Andy.x
				world << Andy.y
				world << Andy.z
				*/

				if(on_rope)
					vel_x = ropeNode.vel_x * ropeNode.base.dt
					vel_y += ropeNode.vel_y * ropeNode.base.dt
					on_rope = 0
					lastRope = ropeNode.base
					ropeNode.mass -= onRopeMass

					ropeNode.base.Detached()

					ropeNode = null
					ropeOffset = 0

				client.clear_input()
				client.unlock_input()
				freezeControls = 0

				density = 1

				//respawn player

				flicker(16)
				invincibleTimer = time + 0.5

				loc = nloc
				set_pos(32 * nloc.x, 32 * nloc.y)
				vel_x = 0
				vel_y = 0

				dead = 0
				health = maxHealth
				UpdateHealth()


			HealthUpdate()
				drinking = 0
				if(health > 0) src<<sound('pain.wav')
				UpdateHealth()

			set_background()
				//layers!
				//the layers are all decimal: 0.1, 0.2, 0.3, 0.4, 0.5

				var/spx, spy
				spx = camera.px
				spy = camera.py
				if(fore1)
					fore1.px = -spx * 1.3 -400
					fore1.py = -spy -75
					fore1.setLayer(3000)

				if(back1)
					back1.px = -spx * 0.7 -400
					back1.py = -spy * 0.2 -300
					back1.setLayer(1.4)

				if(back2)
					back2.px = -spx * 0.6 -400
					back2.py = -spy * 0.15 -300
					back2.setLayer(1.3)

				if(back3)
					back3.px = -spx * 0.5 -400
					back3.py = -spy * 0.1 -300
					back3.setLayer(1.2)

				if(back4)
					back4.px = -spx * 0.4 -400
					back4.py = -spy * 0.05 -300
					back4.setLayer(1.1)

				if(back5)
					back5.setLayer(1)
					back5.px = -400
					back5.py = -300

			updateLayer()
				.=..()
				if(over) over.layer = layer + 0.01
				if(under) under.layer = layer - 0.01
			// Your icon_state depends on your current situation, like this:
			// if you're on a ladder you're climbing
			// if you're not on the ground (and not on a ladder) you're jumping
			// if you're not moving (and are on the ground and not on a ladder) you're standing
			// otherwise you're moving (walking)

			set_state()
				//var/base = base_state ? "[base_state]-" : ""

				if(on_rope)
					//This has two directions for movement and one for static
					icon_state = "Jump1"
					over.icon_state = "Rope-over"
					under.icon_state = "Rope-under"


					if(client.keys[controls.up])
						over.icon_state = "RopeUp-over"
						under.icon_state = "RopeUp-under"

					else if(client.keys[controls.down])
						over.icon_state = "RopeDown-over"
						under.icon_state = "RopeDown-under"


				else if(on_ladder)
					//This has movement state and nonmovement state
					icon_state = "Climb"
					over.icon_state = "Climb-over"
					under.icon_state = "Climb-under"


					if(client.keys[controls.up])
						icon_state = "Climbing"
						over.icon_state = "Climbing-over"
						under.icon_state = "Climbing-under"
						dir = UP

					else if(client.keys[controls.down])
						icon_state = "Climbing"
						over.icon_state = "Climbing-over"
						under.icon_state = "Climbing-under"
						dir = DOWN

				else if(!on_ground)
					//This is based upon vertical velocity...
					if(vel_y > 2)
						icon_state = "Jump1"
						over.icon_state = "Jump1-over"
						under.icon_state = "Jump1-under"


					if(abs(vel_y)<2)
						icon_state = "Jump2"
						over.icon_state = "Jump2-over"
						under.icon_state = "Jump2-under"

					if(vel_y < -2)
						icon_state = "Jump3"
						over.icon_state = "Jump3-over"
						under.icon_state = "Jump3-under"

						if(vel_y < -6)
							over.icon_state = "Jump4-over"
							under.icon_state = "Jump4-under"

					if(dead)
						icon_state = "Death1"
						over.icon_state = "Death1-over"
						under.icon_state = "Death1-under"


					////world<<vel_y
					////world<<icon_state

				else if(moved)
					icon_state = "Run"
					over.icon_state = "Run-over"
					under.icon_state = "Run-under"
					//icon_state = base + MOVING

					if(dead)
						icon_state = "Death2"
						over.icon_state = "Death2-over"
						under.icon_state = "Death2-under"
				else
					icon_state = "Stand"
					over.icon_state = "Stand-over"
					under.icon_state = "Stand-under"
					//icon_state = base + STANDING

					if(dead)
						icon_state = "Death2"
						over.icon_state = "Death2-over"
						under.icon_state = "Death2-under"

				if(frame && frameTimer >= time)
					icon_state = frame
					over.icon_state = "[frame]-over"
					under.icon_state = "[frame]-under"

					flick("[frame]-over",over)
					flick("[frame]-under",under)
				else
					frame = null

			proc
				flicker(t) if(flicker < t) flicker = t  //this sets our flicker timer. Fun fun.

				DrinkTick()
					if(health == maxHealth && !dead) return

					var/drinkRate = 0.5
					health = min(maxHealth,health+drinkRate)
					water = max(0,water-drinkRate)

					/*
					frame = "Drink"
					frameTimer = 0.1
					*/

					UpdateHealth()

				Whip()
					if(on_rope) return 0
					if(dead) return 0
					if(time < whipTimer) return 0
					//this needs to check everything from top left to bottom right within the bounding box
					//It will sort everything that is a subclass of /atom/movable
					var/whipRadius = 160
					var/whipDamage = 10
					//first acquire the list of objects
					var/whipHit[] = front(whipRadius*1.5, -8, whipRadius)
					var/sortedHit[0]

					var/hand_x = (dir==EAST? pwidth/2-6 : -pwidth/2)
					var/hand_y = 48

					//sort the objects via insertion sort
					for(var/atom/movable/A in whipHit)

						if(!sortedHit.len) sortedHit += A
						else
							var/inserted = 0
							for(var/i=1;i<=sortedHit.len;i++)
								var/atom/movable/B = sortedHit[i]
								if(B == A) continue

								var/Brating = -(B.px - px - hand_x) + (B.py - py - hand_y)
								var/Arating = -(A.px - px - hand_x) + (A.py - py - hand_y)

								if(Arating <= Brating)
									sortedHit.Insert(i,A)
									inserted = 1
									break

							if(!inserted) sortedHit += A

					//check for the first object within the maximum radius of the rope
					var/atom/movable/hitAtom
					for(var/atom/movable/A in sortedHit)
						var/dx = A.px - px - hand_x
						var/dy = A.py - py - hand_y
						if(dx*dx+dy*dy > whipRadius*whipRadius)
							continue

						//somehow check if something can be whipped ????????

						if(istype(A,/mob/actor/enemy) || istype(A,/obj/whipPoint))
							hitAtom = A
							break

						//Check for the appropriate type of interaction with this object: Rope or Attack

					var/showWhip = 1
					if(hitAtom)
						//Perform the appropriate type of interaction.

						.=1

						if(istype(hitAtom,/mob/actor/enemy))
							hitAtom:Damage(whipDamage,src)
							showWhip = 1

						//whip rope swing thing
						if(istype(hitAtom,/obj/whipPoint))
							var/obj/rope_base/whip/whip = new(src,hitAtom)

							ropeNode = whip.pieces[whip.pieces.len-1]
							on_rope = 1
							ropeNode.mass += onRopeMass
							showWhip = 0

					//play the whip sound
					whipTimer = time+0.5
					Andy<<sound('Whip.ogg')

					if(showWhip)
						frame = "Whip"
						frameTimer = time + 0.5

						spawn()
							var/image/I = new()//
							I.icon = 'Whip.dmi'
							// new('Whip.dmi')
							I.loc = src
							I.layer = src.layer+1000
							I.dir = src.dir
							I.invisibility = 0

							I.pixel_x = -128 + pixel_x
							I.pixel_y = pixel_y

							client.images += I

							sleep(4)
							del I

					//Will whips have a minimum range???