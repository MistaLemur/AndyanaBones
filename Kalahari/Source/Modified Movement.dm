mob
	actor
		player
			var
				freezeControls = 1
				drinking = 0

			key_down(k)
				if(k == "z" || k == "Z")
					Andy.Whip()

				if(k == "c" || k == "C")
					drinking = 1

				..()

			gravity()
				#ifdef LIBRARY_DEBUG
				if(trace) trace.event("[world.time]: gravity:")
				#endif

				if(on_ladder || on_ground || on_rope) return

				vel_y -= gravity
				if(vel_y < -fall_speed)
					vel_y = -fall_speed

			action(ticks)

				#ifdef LIBRARY_DEBUG
				if(trace) trace.event("[world.time]: start action:")
				#endif

				if(freezeControls) return 0

				// Calling mob.move_to or mob.move_towards will set either the path
				// or destination variables. If either is set, we want to make the
				// mob move as those commands specify, not as the keyboard input specifies.
				// The follow_path proc is defined in mob-pathing.dm.
				if(path || destination)
					follow_path()

				// if the mob's movement isn't controlled by a call to move_to or
				// move_towards, we use the client's keyboard input to control the mob.
				else if(client)

					// the on_ladder proc determines if we're over a ladder or not.
					// the on_ladder var determines if we're actually hanging on it.
					if(on_ladder())
						if(client.keys[controls.up] || client.keys[controls.down])
							if(!on_ladder)
								vel_y = 0
							on_ladder = 1
					else
						on_ladder = 0

					moved = 0
					if(on_ground && lastRope) lastRope = null

					if(drinking)
						DrinkTick()

					if(on_rope)
						if(client.keys[controls.right])
							dir = RIGHT
							AccelerateRope(swingForce)
						if(client.keys[controls.left])
							dir = LEFT
							AccelerateRope(-swingForce)

						if(client.keys[controls.up])
							MoveAlongRope(-2)

						if(client.keys[controls.down])
							MoveAlongRope(2)

						if(jumped)
							jumped = 0
							jump()

					// If we're on a ladder we want the arrow keys to move us in
					// all directions. Gravity will not affect you.
					else if(on_ladder)
						if(client.keys[controls.right])
							dir = RIGHT
							climb(RIGHT)
						if(client.keys[controls.left])
							dir = LEFT
							climb(LEFT)
						if(client.keys[controls.up])
							climb(UP)
						if(client.keys[controls.down])
							climb(DOWN)


					// If you're not on a ladder, movement is normal.
					else
						if(client.keys[controls.right])
							dir = RIGHT
							move(RIGHT)
						if(client.keys[controls.left])
							dir = LEFT
							move(LEFT)
						if(client.keys[controls.up])
							return 0
							//move(UP)
						if(client.keys[controls.down])
							return 0
							//move(DOWN)

					// by default the jumped var is set to 1 when you press the space bar
					if(jumped)
						jumped = 0
						if(can_jump())
							jump()

					slow_down()

				else
					// the slow_down proc will decrease the mob's movement speed if
					// they're not pressing the key to move in their current direction.
					if(moved)
						moved = 0
					else
						slow_down()

				// end of action()

				#ifdef LIBRARY_DEBUG
				if(trace) trace.event("[world.time]: end action:")
				#endif


			movement(ticks)

				if(flicker)
					invisibility = !invisibility  //player
					over.invisibility = !invisibility
					if(over.invisibility) over.loc = src //arms
					else over.loc = null
					under.invisibility = !invisibility
					if(under.invisibility) under.loc = src //arms
					else under.loc = null
					flicker -= 1
				else
					invisibility = 0
					over.invisibility = 0
					under.invisibility = 0

				#ifdef LIBRARY_DEBUG
				if(trace) trace.event("[world.time]: start movement:")
				#endif

				var/turf/t = loc

				// if you don't have a location you're not on the map so we don't
				// need to worry about movement.
				if(!t)
					#ifdef LIBRARY_DEBUG
					if(trace) trace.event("[world.time]: end movement:")
					#endif
					return

				// This sets the on_ground, on_ceiling, on_left, and on_right flags.
				set_flags()

				// apply the effect of gravity
				gravity()

				// handle the movement action. This will handle the automatic behavior
				// that is triggered by calling move_to or move_towards. If the mob has
				// a client connected (and neither move_to/towards was called) keyboard
				// input will be processed.
				action(ticks)

				if(!on_rope)
					//grab ropes
					GrabRope()

				// set the mob's icon state
					set_state()

					// perform the movement
					pixel_move(vel_x, vel_y)

				else
					UpdateRopePos()

					set_state()

				#ifdef LIBRARY_DEBUG
				if(trace) trace.event("[world.time]: end movement:")
				#endif

			jump()
				//world<<"JUMP"
				#ifdef LIBRARY_DEBUG
				if(trace) trace.event("[world.time]: jump:")
				#endif

				vel_y = jump_speed

				if(on_rope)
					vel_x = ropeNode.vel_x * ropeNode.base.dt
					vel_y += ropeNode.vel_y * ropeNode.base.dt
					on_rope = 0
					lastRope = ropeNode.base
					ropeNode.mass -= onRopeMass

					ropeNode.base.Detached()

					ropeNode = null
					ropeOffset = 0

			pixel_move(dpx, dpy)

				var/list/front
				if(dpx < 0)
					front = left(-dpx)
				else
					front = right(dpx)

				for(var/mob/pushable/b in front)
					//world<<"PUSHING B?"
					Bump(b)
					//b.Bumped(src)

				// then perform your move
				..()