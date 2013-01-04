mob
	can_bump(mob/b)
		if(istype(b, /mob/pushable) || istype(b, /mob/platforms) || istype(b, /mob/puzzles/doors))
			return 1
		else if(ismob(b))
			return 0
		else
			return ..()

	pushable
		var
			pushSpeed = 2 //This is the pixels per tick when being pushed
		set_state()
		Bumped(atom/A)
			var/dx = A.px - px
			var/dy = A.py - py

			//world<<"BUMPED: [dx], [dy]"

			if(dx > 0 && dx < pwidth && dy > 0 && dy < pheight) return ..()

			if(dx < 0)
				pixel_move(pushSpeed,0)
			else if(dx > 0)
				pixel_move(-pushSpeed,0)
			else if(dy > 0)
				pixel_move(0,-pushSpeed)
			else if(dy < 0)
				pixel_move(0,pushSpeed)


		stoneBlock64
			density = 1
			icon = 'StoneBlock64.dmi'
			pwidth = 62
			pheight = 63
			lheight = 60

			pixel_x = -1

		stoneBlock32
			density = 1
			icon = 'StoneBlock32.dmi'
			pwidth = 32
			pheight = 31
			lheight = 60

			pixel_x = -1

		stoneBlock96
			density = 1
			icon = 'StoneBlock96Thin.dmi'
			pwidth = 32
			pheight = 96
			lheight = 60

			pixel_x = -1


	Pedestals
		icon = 'Pedestal.dmi'
		density = 0
		lheight = 30
		pixel_y = 4
		var/maptxt = "\red Defaulted by a Canadian. Whoops. Better tell Mechanios."

		action()
			for(var/mob/m in inside())
				if(m.client)
					if(Andy.mptext.maptext != maptxt) Andy.mptext.update(maptxt, 100)


		Level_1
			tutorialmove/maptxt = "Use the \[Arrow Keys] to move!"
			tutorialjump/maptxt = "Press the \[Space] to jump!"
			tutorialvines/maptxt = "Push Up and Down to climb on vines and ladders!"
			tutorialplatform/maptxt = "Platforms will carry you across gaps or up cliffs!"
			tutorialswing/maptxt = "Push \[Left] and \[Right] to swing on vines!"
			tutorialpush/maptxt = "Bump into blocks and other objects to move them."
			tutorialpuzzle/maptxt = "Pressure plates often open doors! Push a block or step on them to activate!"
			tutorialchests/maptxt = "Touch chests to open them! They often have trinkets and treasures!"
			tutorialcheckpoint/maptxt = "This glowing ring is a checkpoint. They save your progress!"
			tutorialhidden/maptxt = "Some wall hide passages! They often lead to treasure!"
			tutorialend/maptxt = "Good job! Continue on to the next level!"
			tutorialenemy/maptxt = "Be sure to watch out for snakes! Andy dislikes them.  Press \[C] to drink your canteen to restore health!"
			tutorialenemy2/maptxt = "The locals will also be trying to get you! They don't like adventurers!"
			tutorialwhipattack/maptxt = "Your whip can hurt the Natives! Press \[Z] to use your whip!"
			tutorialwhipswing/maptxt = "Swing your whip at that point and swing across!"
			zruins1/maptxt = "These sure are some ruins!"
			zruins2/maptxt = "Maybe you could push those blocks...!"
			zruins3/maptxt = "This place looks really complex!"
			zruins4/maptxt = "You found it! The Fountain of Youth!"

			/*stepping_on(mob/m)
				if(m.client)
					world << "Yo"
					Andy.mptext.state = 1
					Andy.mptext.update("Welcome! This is Andyana Bones!")

			stepped_off(mob/m)
				if(m.client)
					Andy.mptext.state = 0
					Andy.mptext.update(Andy.mptext.lasttext, 100)*/
obj
	rope_base
		_20/numPieces=20
		_10/numPieces=10
		_5/numPieces=5


obj
	chest
		var
			open = 0
			items = 20

		icon = 'Chests.dmi'
		icon_state = "woodClose"
		pixel_x = -8

		lheight = 48

		Trigger(mob/actor/M)
			if(ismob(M) && M.client && !open)
				open = 1
				icon_state = "woodOpen"
				//opening sound
				M<<sound('chestOpen.wav')

				for(var/i = 1;i<=items;i++)
					var/ntype = pick(typesof(/mob/trinket) - /mob/trinket)
					//var/mob/trinket/O = new ntype(loc)
					new ntype(loc,1)
					//loot sound
		chest_5/items = 5
		chest_10/items = 10
		chest_15/items = 15
		chest_rand
			New()
				..()
				items = rand(1,30)

mob
	trinket
		icon = 'Trinkets.dmi'
		var
			grabbable = 0
			points = 100
			grabTimer

		density = 0
		pheight = 16
		pwidth = 16

		pixel_y = 3

		lheight = 100

		Sapphire
			icon_state = "Sapphire"
		Ruby
			icon_state = "Ruby"
		Emerald
			icon_state = "Emerald"
		Topaz
			icon_state = "Topaz"
		Amethyst
			icon_state = "Amethyst"
			points = 200
		Diamond
			icon_state = "Diamond"
			points = 400
		Crown
			icon_state = "Crown"
			points = 200
		Necklace
			icon_state = "Necklace"
			points = 200
		Crown
			icon_state = "Crown"
			points = 200
		Coin
			icon_state = "Coin"
			points = 50

		set_state()


		New(loc, pop = 0)
			.=..(loc)

			grabTimer = time+0.5

			py += 24
			if(pop)
				vel_x = rand(-20,20)
				vel_y = rand(5,20)
			on_ground = 0

		action()
			.=..()
			if(on_ground && grabTimer <= time)
				grabbable = 1

			if(grabbable)
				if(Andy in inside())
					score += points
					//play the awesome sound
					Andy << sound('Trinket.wav',0,0,0,200)

					Andy.UpdatePoints()

					del src