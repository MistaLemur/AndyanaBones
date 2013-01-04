var
	loaded = 0
	time = 0
	score = 0

	activeAtoms[0]

	mob/actor/player/Andy

world
	name = "Andyana Bones and the Fountain of Youth"

	fps = 30

	view = "25x19"
	//view = "13x9"

	New()
		.=..()

		Init()

		spawn(world.tick_lag)
			LogicLoop()


proc
	Init()
		LoadRopeCache()

		var/client/C
		for(C) break
		winset(C,"default.child1","left=titleScreen")

		loaded = 1

	LogicLoop()
		while(1)
			var/dt = world.tick_lag/10
			time += dt
			sleep(world.tick_lag)

			for(var/atom/A in activeAtoms)
				if(time >= A.tickTimer)
					A.Tick()

atom
	var
		tickTimer = 0
		activeBool = 0
	proc
		Tick()

	New()
		.=..()
		if(activeBool)
			activeAtoms += src

	Del()
		if(activeBool) activeAtoms -= src
		.=..()

mob/actor/player
	verb
		newGame()
			winset(src,"default.child1","left=mapScreen")

			LoadLevel(1)




	proc
		LoadLevel(n)
			health = maxHealth
			water = maxWater

			client.clear_input()
			client.lock_input()

			if(n == 1)

			//	client.clear_input()
			//	client.lock_input()

			//	var/turf/T = locate(24,34,1)
			//	Spawn(T)

				fore1 = background('JungleBackdrop1.png', REPEAT_X)
				back1 = background('JungleBackdrop1.png', REPEAT_X)
				back2 = background('JungleBackdrop2.png', REPEAT_X)
				back3 = background('JungleBackdrop3.png', REPEAT_X)
				back4 = background('JungleBackdrop4.png', REPEAT_X)
				back5 = background('JungleBackdrop5.png', 0)

				fore1.show()
				back1.show()
				back2.show()
				back3.show()
				back4.show()
				back5.show()

				var/turf/T = locate(24,24,1)
				//var/turf/T = locate(120,24,1)
				Spawn(T)

				Andy.mptext = new /obj/onScreen/mapText/mptext(client, 3, 0, 3, 0)
				Andy.mptext.invisibility = 1
			//	mptext.update("Welcome to Andyana Bones. Push space to jump! The arrow keys to move Andy!", 400)
				InitHUD()

				Andy << sound('stage1.ogg',1,0,1)
				//dialogues?

				//story?


				//map initialization??

			if(n == 2)

				world << spawnLoc
				var/turf/T = locate("Level 2")
				Spawn(T)

				Andy.mptext.update("Look at all these ruins!", 60)



			sleep(10)
			spawnLoc = loc
			freezeControls = 0

			client.clear_input()
			client.unlock_input()
