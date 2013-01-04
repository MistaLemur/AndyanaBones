
turf
	var/randState = 1
	var/castShadow = 0

	var/icon/shadowIcon = 'TileShadow1.dmi'

	New()
		.=..()
		if(randState && icon) icon_state = pick(icon_states(icon))

		if(castShadow && shadowIcon)
			var/backTurfs[] = bottom(4)
			if(locate(/turf/background) in backTurfs)
				var/image/I = new(shadowIcon)
				I.loc = src
				I.pixel_y = -icon_height
				overlays += I
				del I
	ladders
		ladder = 1
		vines
			icon = 'Vines.dmi'
			icon_state = "a"
		ladder
			icon = 'Ladders.dmi'
			icon_state = "a"

	wall
		castShadow = 1

		density = 1

		pheight = 32
		lheight = 30

		jungle_grassyDirt
			icon = 'GrassyDirt.dmi'

			ramp
				icon = 'GrassyDirtRamp.dmi'

				randState = 0

				pwidth = 32
				pheight = 16


				rampRightA
					// The pleft and pright variables are used to create ramps
					pleft = 32
					pright = 16

					icon_state = "rightA"

				rampRightB
					// The pleft and pright variables are used to create ramps
					pleft = 16
					pright = 0

					icon_state = "rightB"

				rampLeftA
					// The pleft and pright variables are used to create ramps
					pleft = 16
					pright = 32

					icon_state = "leftA"

				rampLeftB
					// The pleft and pright variables are used to create ramps
					pleft = 0
					pright = 16
					icon_state = "leftB"

				rampRightC
					pleft = 32
					pright = 0
					icon_state = "right"
					icon = 'GrassyDirtRamp45.dmi'

				rampLeftC
					pleft = 0
					pright = 32
					icon_state = "left"
					icon = 'GrassyDirtRamp45.dmi'


		jungle_dirt
			icon = 'Dirt.dmi'
			ramp
				icon = 'DirtRamp.dmi'

				randState = 0

				pwidth = 32
				pheight = 16


				rampRightA
					// The pleft and pright variables are used to create ramps
					pleft = 32
					pright = 16

					icon_state = "rightA"

				rampRightB
					// The pleft and pright variables are used to create ramps
					pleft = 16
					pright = 0

					icon_state = "rightB"

				rampLeftA
					// The pleft and pright variables are used to create ramps
					pleft = 16
					pright = 32

					icon_state = "leftA"

				rampLeftB
					// The pleft and pright variables are used to create ramps
					pleft = 0
					pright = 16
					icon_state = "leftB"

				rampRightC
					pleft = 32
					pright = 0
					icon_state = "right"
					icon = 'DirtRamp45.dmi'

				rampLeftC
					pleft = 0
					pright = 32
					icon_state = "left"
					icon = 'DirtRamp45.dmi'

		stone
			icon = 'StoneWall.dmi'
		stone_fake
			icon = 'StoneWall.dmi'
			density = 0
			lheight = 100


	background
		pheight = 0
		density = 0
		lheight = 0

		castShadow = 0

		dirt
			icon = 'DirtBack.dmi'
			edges
				icon = 'DirtBackEdges.dmi'
				randState = 0
				_1/icon_state = "1"
				_2/icon_state = "2"
				_3/icon_state = "3"
				_4/icon_state = "4"


		stone
			icon = 'StoneBack.dmi'
			icon_state = "mossy"
			randState = 0
			_1/icon_state = "mossy 1"
			_2/icon_state = "mossy 2"
			_3/icon_state = "mossy 3"
			_4/icon_state = "mossy 4"
			_5/icon_state = "mossy 5"

			_1a/icon_state = "mossy 1a"
			_4a/icon_state = "mossy 4a"

	DeathTurf
		icon = 'dirt.dmi'
		lheight = 50
		density = 1
		stepped_on(mob/actor/m)
			if(m.client && !m.dead)
				m.invincibleTimer = 0
				spawn(0.5) m:knockback(src, 8)
				m.Damage(9999,null)
		spikes
			icon = 'spikes.dmi'
			lheight = 100



obj
	decor
		stonePattern
			density = 0
			lheight = 1
			icon = 'StoneBackPattern.dmi'
			pixel_y = 8
		stonePillar
			density = 0
			lheight = 30
			pixel_x = -11
			pixel_y = -3
			icon = 'StonePillar.dmi'

		plants
			icon = 'Jungle Plants.dmi'
			density = 0
			lheight = 30
			pixel_y = 4
			New()
				.=..()
				if(icon) icon_state = pick(icon_states(icon))

	checkpoint
		pixel_y = 3
		icon = 'Checkpoint.dmi'
		icon_state = "checkpoint"

		lheight = 100

		Trigger(mob/actor/M)
			if(ismob(M) && M.client)
				if(M.spawnLoc != loc)
					flick("checkpoint-flash",src)

				M.spawnLoc = loc
		NextPoint
			Trigger(mob/actor/M)
				.=..()
				if(Andy == M )Andy << sound('stage2.ogg',1,0,1)
mob
	fountain
		icon = 'Fountain.dmi'
		lheight = 900
		pwidth = 64
		pheight = 128
		action()
			for(var/mob/actor/player/p in inside()) Andy.mptext.update("Thanks for playing!")
