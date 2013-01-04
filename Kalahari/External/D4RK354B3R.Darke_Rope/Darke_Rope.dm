#define DEBUG
var
	const
		lengthPerNode = 15


	iconCache[0]

	drawThickness = 1
	gdrawColor = rgb(96,160,0)//rgb(160,96,0)

/*
mob/verb
	RopeLength()
		for(var/obj/rope_base/base)
			var/nlength = lengthPerNode * base.numPieces
			var/length = base.Length()
			//world<<"input length: [nlength] :: true length: [length]"

	RandomMove()
		for(var/obj/rope_base/base)
			var/index = round(rand(10,10)/10 * base.pieces.len)
			var/obj/rope_piece/piece = base.pieces[index]
			piece.vel_x += rand(100,250) * pick(-1,1)
			//piece.vel_y += rand(-50,50)

	IconCacheSize()
		//world<<"[iconCache.len] icons in the cache"

	SaveIconCache()
		var/saveList[0]
		for(var/index in iconCache)
			if(index in saveList) continue
			saveList += index

		var/text = dd_list2text(saveList, "\n")

		text2file(text, "cacheIndexes.txt")

	LoadIconCache()
		var/loadList[] = dd_file2list("cacheIndexes.txt")
		//world<<"Loading rope cache: [loadList.len] entries"

		var/messageProgress = 0.1
		for(var/i=1;i<=loadList.len;i++)
			var/index = loadList[i]
			var/cInd = findtext(index,",")
			var/dx = text2num(copytext(index,1,cInd))
			var/dy = text2num(copytext(index,cInd+1,0))

			var/icon/I = DrawLine(dx,dy,drawColor,drawThickness)

			iconCache[index] = I

			if(i/loadList.len >= messageProgress)
				messageProgress += 0.1
				//world<<"Loading rope cache [round(i/loadList.len*100)]% completed"

			sleep(0)

		//world<<"Loading rope cache completed."
*/

proc
	LoadRopeCache()
		var/loadList[] = dd_file2list("cacheIndexes.txt")

		var/messageProgress = 0.1
		for(var/i=1;i<=loadList.len;i++)
			var/index = loadList[i]
			var/cInd = findtext(index,",")
			var/dx = text2num(copytext(index,1,cInd))
			var/dy = text2num(copytext(index,cInd+1,0))

			var/icon/I = DrawLine(dx,dy,rgb(96,160,0),drawThickness)
			iconCache["[index]:[rgb(96,160,0)]"] = I

			var/icon/U = DrawLine(dx,dy,rgb(160,96,0),drawThickness)
			iconCache["[index]:[rgb(160,96,0)]"] = U

			if(i/loadList.len >= messageProgress)
				messageProgress += 0.1
				world<<"Loading cache [round(i/loadList.len*100)]% completed"

			sleep(0)

obj
	rope_base //This is the object that is placed onto the map and manages rope pieces.
		var
			numPieces=20 //This is in pixels
			pieces[0] //a list of all of the rope pieces.

			obj/rope_piece/basePiece

			//Spring constant and Damping constant
			springK = 50
			dampK = 0.1
			frictionK = 0
			nodeMass = 1

			//icon cache
			//format: "[dx],[dy] = \icon"

			gravity = 20

			canGrab = 1
			canClimb = 1

			dt
			lt

			drawColor = rgb(96,160,0)

		icon = 'RopeIcons.dmi'
		icon_state = "base"

		whip
			canClimb = 0
			drawColor = rgb(160,96,0)
			numPieces = 7

			New(mob/actor/player/M, atom/movable/target)
				loc = target

				while(!isturf(loc)) loc = loc.loc

				px = x*32 + step_x
				py = y*32 + step_y

				var/hand_x = (M.dir==EAST? M.pwidth/2-6 : -M.pwidth/2)
				var/hand_y = 48

				var/px2 = M.px + hand_x
				var/py2 = M.py + hand_y

				var/dx = px2 - px, dy = py2 - py

				//if(dx*dx + dy*dy > numPieces * numPieces * lengthPerNode * lengthPerNode * 1.05)
				//	del src

				Init(dx,dy)

				spawn()
					lt = world.time
					while(1)
						dt = (world.time - lt)/(10*world.tick_lag)*0.5
						////world<<dt
						Process()
						Process()
						lt = world.time
						sleep(world.tick_lag*1)
						sleep(0)

			Init(dx,dy)
				var/obj/rope_piece/currentPiece = new(src,0,0,0)
				basePiece = currentPiece
				basePiece.can_grab = 0
				basePiece.px = px
				basePiece.py = py
				//pieces += currentPiece

				for(var/i=1;i<=numPieces;i++)
					//lengthLeft = max(0,lengthLeft-lengthPerNode)
					var/u = i/numPieces
					var/tpx, tpy
					tpx = u * dx// + (1-u) * px1
					tpy = u * dy// + (1-u) * py2

					var/obj/rope_piece/tempPiece = new(src,tpx,tpy, nodeMass,i)
					currentPiece.next = tempPiece
					tempPiece.prev = currentPiece

					pieces += tempPiece
					currentPiece = tempPiece

				currentPiece.mass *=2
				currentPiece.can_grab = 0

			Detached()
				del src

		New()
			.=..()
			Init()

			spawn()
				lt = world.time
				while(1)
					dt = (world.time - lt)/(10*world.tick_lag)*0.5
					////world<<dt
					Process()
					Process()
					lt = world.time
					sleep(world.tick_lag*1)
					sleep(0)

		Del()
			for(var/atom/A in pieces)
				del A
			del basePiece
			.=..()


		proc
			Detached()

			Length()
				var/s = 0
				var/obj/rope_piece/piece = basePiece
				while(piece.next)
					var/dx = piece.next.off_x - piece.off_x
					var/dy = piece.next.off_y - piece.off_y
					var/ds = sqrt(dx*dx+dy*dy)
					s += ds

					piece = piece.next
				return s
			Init()
				//Create nodes along length of rope
				//Every rope has at least 2 nodes

				var/obj/rope_piece/currentPiece = new(src,0,0,0)
				basePiece = currentPiece
				basePiece.can_grab = 0
				basePiece.px = px
				basePiece.py = py
				//pieces += currentPiece

				for(var/i=1;i<=numPieces;i++)
					//lengthLeft = max(0,lengthLeft-lengthPerNode)

					var/obj/rope_piece/tempPiece = new(src,0,-i*lengthPerNode, nodeMass,i)
					currentPiece.next = tempPiece
					tempPiece.prev = currentPiece

					pieces += tempPiece
					currentPiece = tempPiece

				currentPiece.mass *=2
				currentPiece.can_grab = 0

			Process()
				var/obj/rope_piece/piece
				for(var/i=1;i<=pieces.len;i++)
					piece = pieces[i]
					var/fx, fy

					//first evaluate forces on every rope piece
					fy += -gravity * piece.mass //gravity

					//Damping force so that the rope is converging system
					fx += -dampK * (piece.vel_x)
					fy += -dampK * (piece.vel_y)

					//Spring forces to emulate intrarope tension
					if(piece.prev)
						var/dx = piece.prev.off_x - piece.off_x
						var/dy = piece.prev.off_y - piece.off_y
						var/dist = max(0.0001, sqrt(dx*dx+dy*dy))


						fx += (dist-lengthPerNode) * springK * dx/dist
						fy += (dist-lengthPerNode) * springK * dy/dist

					if(piece.next)
						var/dx = piece.next.off_x - piece.off_x
						var/dy = piece.next.off_y - piece.off_y
						var/dist = max(0.0001, sqrt(dx*dx+dy*dy))


						fx += (dist-lengthPerNode) * springK * dx/dist
						fy += (dist-lengthPerNode) * springK * dy/dist


					//Then accelerate each rope piece
					piece.acc_x = fx/piece.mass
					piece.acc_y = fy/piece.mass





				for(var/i=1;i<=pieces.len;i++)
					piece = pieces[i]
					//Then apply rope velocities

					//Euler's Method of numerical Integration

					piece.vel_x += piece.acc_x * dt
					piece.vel_y += piece.acc_y * dt

					piece.off_x += piece.vel_x * dt// + 1/2 * piece.acc_x*dt*dt
					piece.off_y += piece.vel_y * dt// + 1/2 * piece.acc_y*dt*dt

					var/nx, ny, npx, npy
					npx = piece.off_x%icon_width
					npy = piece.off_y%icon_height
					nx = round((piece.off_x - npx +15)/32) + x
					ny = round((piece.off_y - npy +15)/32) + y

					piece.x = nx
					piece.y = ny
					piece.step_x = npx
					piece.step_y = npy

					piece.px = piece.off_x + px
					piece.py = piece.off_y + py


					//Then draw and apply.

					piece.pixel_x = 15//piece.off_x+15
					piece.pixel_y = 15//piece.off_y+15

					piece.updateLayer()

					if(piece.prev)
						var/dx = round(piece.prev.off_x - piece.off_x,1)
						var/dy = round(piece.prev.off_y - piece.off_y,1)

						var/index = "[dx],[dy]:[drawColor]"
						var/icon/I

						if(iconCache[index])
							I = iconCache[index]
						else
							I = DrawLine(dx,dy,drawColor,drawThickness)
							iconCache[index] = I

						piece.icon = I

						if(dx < 0) piece.pixel_x -= I.Width()
						if(dy < 0) piece.pixel_y -= I.Height()

	rope_piece
		animate_movement = 0
		var
			index
			obj/rope_base/base
			obj/rope_piece //doubly linked list
				prev
				next

			vel_x
			vel_y
			acc_x
			acc_y

			mass

			//These are pixel offsets relative to the rope base
			off_x
			off_y

			can_grab = 1
		New(nbase,x,y,m, ind)
			base = nbase
			loc = base.loc
			off_x = x
			off_y = y
			mass = m
			index = ind

			//overlays += icon('RopeIcons.dmi',"node")

proc
	sign(x) //Should get bonus points for being the most compact code in the world!
		return ((x<0)?-1:((x>0)?1:0))

	DrawLine(dx,dy,dColor,dThick)
		var/adx = abs(dx)
		var/ady = abs(dy)
		var/icon/I = new('RopeIcons.dmi',"blank")
		I.Crop(1,1,(adx+dThick)+1,(ady+dThick)+1)
		var/px = 1+dThick
		var/py = 1+dThick

		if(dx < 0) px = adx+1
		if(dy < 0) py = ady+1

		var/d = sqrt(dx*dx+dy*dy)

		if(d > 0)

			for(var/i=0;i<=d+0.5;i++)
				var/ox = dx/d * i
				var/oy = dy/d * i

				var/draw_x = px+ox
				var/draw_y = py+oy

				//if(draw_x <= 0 || draw_y <= 0) //world<<"BAD DRAW: [dx], [dy]"

				I.DrawBox(dColor,draw_x-dThick,draw_y-dThick,draw_x+dThick,draw_y+dThick)

		else
			I.DrawBox(dColor,px-dThick,py-dThick,px+dThick,py+dThick)

		return I

mob
	actor
		player
			var
				tmp
					on_rope
					obj/rope_piece/ropeNode
					ropeOffset
					obj/rope_base/lastRope

					onRopeMass = 1 //The mass added to rope nodes while you're hanging

					swingForce = 400

			proc
				GrabRope()
					if(on_rope || on_ladder) return 0
					////world<<"Trying to grab ropes"

					var/hand_x = (dir==EAST? pwidth : 0) + px
					var/hand_y = (60) + py

					var/dx = 100
					var/dy = 100
					var/obj/rope_piece/cand

					for(var/obj/rope_piece/piece in front(8, 48, 60))
						if(!piece.can_grab) continue
						if(piece.base == lastRope) continue
						if(!piece.base.canGrab) continue
						var/ndx = piece.px - hand_x
						var/ndy = piece.py - hand_y

						if(ndx*ndx+ndy*ndy < dx*dx+dy*dy)
							cand = piece
							dx = ndx
							dy = ndy

					if(cand)
						//world<<"GRABBED ROPE. Rope Index: [cand.index]"
						ropeNode = cand
						on_rope = 1
						ropeOffset = 0
						lastRope = cand.base

						cand.mass += onRopeMass

						cand.vel_x = vel_x*5
						cand.vel_y = vel_y*5

						return 1

				MoveAlongRope(ds)
					if(!on_rope) return
					if(!ropeNode.base.canClimb) return

					ropeOffset += ds
					var/obj/rope_piece/oldNode = ropeNode

					//world<<ropeOffset

					if(abs(ropeOffset) > (lengthPerNode/2))
						if(ropeOffset < 0) //prev
							if(!ropeNode.prev || !ropeNode.prev.can_grab) ropeOffset = -lengthPerNode/2
							else
								ropeOffset = lengthPerNode + ropeOffset
								ropeNode = ropeNode.prev
								//world<<"Should have changed ropes to prev"

						else if(ropeOffset > 0) //next
							if(!ropeNode.next || !ropeNode.next.can_grab) ropeOffset = lengthPerNode/2
							else
								ropeOffset = ropeOffset - lengthPerNode
								ropeNode = ropeNode.next
								//world<<"Should have changed ropes to next"

					if(oldNode != ropeNode)
						ropeNode.mass += onRopeMass
						oldNode.mass -= onRopeMass

						//world<<"Changed Ropes! Rope Index: [ropeNode.index]"

				UpdateRopePos()
					if(!on_rope) return

					var/u = ropeOffset / lengthPerNode
					var/ou = u
					var/v
					var/hand_x = (dir==EAST? pwidth/2-6 : -pwidth/2)
					var/hand_y = 48

					var/npx
					var/npy

					if(ou < 0 && ropeNode.prev) //prev
						u = abs(u)
						v = 1-u

						npx = ropeNode.prev.px * u + ropeNode.px * v -hand_x
						npy = ropeNode.prev.py * u + ropeNode.py * v -hand_y

					else if(ou > 0 && ropeNode.next) //next
						u = abs(u)
						v = 1-u

						npx = ropeNode.next.px * u + ropeNode.px * v -hand_x
						npy = ropeNode.next.py * u + ropeNode.py * v -hand_y

					else//on the spot

						npx = ropeNode.px -hand_x
						npy = ropeNode.py -hand_y

					set_pos(npx, npy)

				AccelerateRope(a_x)
					if(!on_rope) return
					if(a_x == 0) return
					var/collision = 0

					if(a_x > 0)
						//check to the right
						for(var/atom/A in right(icon_width/4))
							if(can_bump(A))
								collision = 1
								break
					if(a_x < 0)
						//check to the left
						for(var/atom/A in left(icon_width/4))
							if(can_bump(A))
								collision = 1
								break

					if(collision) return

					var/moment_arm = 1

					if(ropeNode.prev)
						var/dx = ropeNode.base.px - ropeNode.px
						var/dy = ropeNode.base.py - ropeNode.py
						var/d = sqrt(dx*dx+dy*dy)

						if(abs(dy/d) < sin(80))
							moment_arm = 0
						else
							var/asdf = abs(dy/d) - 0.984
							moment_arm = asdf / 0.02

					ropeNode.vel_x += a_x * ropeNode.base.dt * moment_arm

obj
	whipPoint
		icon = 'RopeIcons.dmi'
		icon_state = "whipPoint"