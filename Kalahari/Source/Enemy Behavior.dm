mob
	actor
		enemy
			var/flicker = 0
			Damage(damage, mob/actor/source)
				flicker = 60*world.tick_lag
				health -= damage
				if(health <= 0) die()

			var
				sleep_time = 60
				hitDamage = 5
			proc
				die()
					//defined in each
				hurt(mob/actor/player/p)
					if(p.dead) return
					if(!p.flicker)
						p.knockback(src, 8)
						p.flicker(30)
					if(p.Damage(hitDamage,src))
						p.invincibleTimer = time + 1
			action()
				if(dead) return

				move(dir)

				if(at_edge())
					turn_around()

				for(var/mob/actor/player/p in inside())
					hurt(p)

				..()

			lheight = 60

			rollingBoulder
				icon = 'RollingBoulder.dmi'
				var
					rollSpeed = 6

				pwidth = 128
				pheight = 128
				lheight = 128

				hitDamage = 10

				dir = RIGHT

				action()
					if(on_ground)
						vel_x = min(rollSpeed, vel_x + 1)
					//	var/icon/I = new src.icon
					//	I.Turn(15)
					//	src.icon = I

					for(var/mob/actor/player/p in inside()+front(vel_x))
						hurt(p)

				Damage() return 0

			snake
				icon = 'Snake.dmi'
				icon_state = "Stand"


				name = "Venemous Snake"
				pwidth = 24
				pheight = 24

				move_speed = 1
				dir = RIGHT
				scaffold = 1

				Damage() return 0

				die()

					dead = 1
					icon_state = "goomba-smushed" //lol
					vel_x = 0

					scaffold = 0

					spawn(10)
						del src

				bump(atom/a, d)
					if(d == LEFT || d == RIGHT) turn_around()



			bullet  //VENEMOUS NEEDLE, NIG.

				pwidth = 4
				pheight = 2
				pixel_y  = 9
				icon = 'bullet.dmi'
				scaffold = 1
				//icon_state = "bullet"

				New(mob/m, d)

					var/dx = 0
					var/dy = 0

					if(d & EAST)
						dx = 6
						pixel_x = 3
					if(d & WEST)
						dx = -6
						pixel_x = -10
					if(d & NORTH) dy = 6
					if(d & SOUTH) dy = -6

					vel_x = dx
					vel_y = dy

					set_pos(m)

					..()

				can_bump(atom/a)
					if(isturf(a))
						return a.density
					return 0

				bump(atom/a)
					del src

				movement()
					pixel_move(vel_x,vel_y)

					for(var/mob/m in inside())
						if(m.client)
							hurt(m)
							del src

					if(!loc)
						del src

				set_state() return 0
				action() return 0

			shaman
				icon = 'Shaman.dmi'
				icon_state = "Shaman"
				dir = RIGHT
				dead = 0
				pwidth = 24
				pheight = 40
				scaffold = 1
				pixel_y = -3

				var
					state = STANDING

				New()
					..()

					spawn(30) shoot_loop()

				die()
					dead = 1
					spawn(30) del src

				set_state() return 0
				action()
					if(flicker > 0)
						flicker --
						invisibility = !invisibility
					else invisibility = 0

					for(var/mob/m in inside())
						if(m.client)
							hurt(m)

				proc
					shoot_loop()
						while(!dead)

							new /mob/actor/enemy/bullet(src, dir)

							sleep(sleep_time)


				left
					dir = LEFT

				right
					dir = RIGHT

				both
					dir = RIGHT
					shoot_loop()
						while(!dead)

							face(Andy)

							new /mob/actor/enemy/bullet(src, dir)

							sleep(sleep_time)

