var
	const
		HUD_LAYER = 9000


		scx = 13
		scy = 10


obj
	HUDObj

		maptext_width = 600
		maptext_height = 600
		layer = HUD_LAYER

		var
			mob/client
			image/image
			atom/clickAtom

			callContext = null
			callFunction = null
			callParams = null

			children[0]
			obj/HUDObj/parent

		mouse_opacity = 0

		Click()
			if(clickAtom)
				return clickAtom:Click()

			if(callContext && callFunction)
				if(!callParams)
					return call(callContext,callFunction)(usr)
				else
					return call(callContext,callFunction)(callParams)

			if(!callContext && callFunction)
				if(!callParams)
					return call(callFunction)(usr)
				else
					return call(callFunction)(callParams)
			..()

		MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
			if(clickAtom)
				return clickAtom:MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
			else
				return ..()

		proc
			addChild(obj/HUDObj/O)
				children += O
				O.parent = src

			addParent(obj/HUDObj/O)
				O.children += src
				parent = O

		Del()
			if(client)
				if(client.client)
					client.client.images -= image
			del image

			for(var/obj/HUDObj/O in children)
				del O

			..()

mob
	var/tmp
		hud[0] //List of HUD objects
		updateHealth
	proc
		AddHUD(t,icon/i,istate,sx,sy,tsx=scx,tsy=scy,nlayer=HUD_LAYER,smap="") //Add an HUD object
			//sx and sy are in pixels relative to the center...

			sx=round(sx,1)
			sy=round(sy,1)

			var/sl = "[tsx]:[sx],[tsy]:[sy]"

			if(smap!=null && smap != "") sl = "[smap]:[sl]"

			if(hud[t])
				var/obj/HUDObj/O = hud[t]
				O.client = src
				O.tag = t

				O.icon = i
				O.icon_state = istate

				if(O.screen_loc != sl) O.screen_loc = sl

				if(O.layer!=nlayer) O.layer = nlayer

				return O

			var/obj/HUDObj/O = new()
			O.client = src
			O.tag = t

			O.icon = i
			O.icon_state = istate

			O.screen_loc = sl

			if(O.layer!=nlayer) O.layer = nlayer

			client.screen += O

			hud[t] = O

			return O

		RemoveHUD(t) //Remove an HUD object

			var/obj/HUDObj/O = hud[t]
			hud -= t
			if(O) del O

		CheckHUD(t)
			return hud[t]

		ClearHUD()
			for(var/t in hud)
				var/obj/HUDObj/O = hud[t]
				del O

			hud.Cut()

		InitHUD()
			ClearHUD()
			//add shit

		ClearHUDTag(t)
			for(var/i in hud)
				if(findtext(i,t))
					RemoveHUD(i)

		ClearPopup()
			ClearHUDTag("popup")

	actor/player
		InitHUD()
			.=..()
			UpdateHealth()
			UpdatePoints()

		proc
			UpdateHealth()
				var/healthSize = 3
				var/waterSize = 2

				var/healthPixels = max(1,healthSize * 48 * health/maxHealth)
				var/waterPixels = max(1,waterSize * 48 * water/maxWater)

				var/sx = 2
				var/sy = 18

				var/off_x = 0
				AddHUD("HealthIcon",'Bars.dmi',"hleft",0,0,sx,sy)
				for(off_x = 1; off_x <= healthSize; off_x ++)
					AddHUD("HealthMid[off_x]",'Bars.dmi',"hmid",48*off_x,0,sx,sy)
				AddHUD("HealthRight",'Bars.dmi',"hright",48*off_x,0,sx,sy)

				var/icon/healthIcon = icon('Bars.dmi',"hbar")
				healthIcon.Scale(healthPixels,48)

				AddHUD("HealthBar",healthIcon,null,48,0,sx,sy)


				off_x = 0
				AddHUD("WaterIcon",'Bars.dmi',"wleft",0,-16,sx,sy-1)
				for(off_x = 1; off_x <= waterSize; off_x ++)
					AddHUD("WaterMid[off_x]",'Bars.dmi',"wmid",48*off_x,-16,sx,sy-1)
				AddHUD("WaterRight",'Bars.dmi',"wright",48*off_x,-16,sx,sy-1)

				var/icon/waterIcon = icon('Bars.dmi',"wbar")
				waterIcon.Scale(waterPixels,48)

				AddHUD("WaterBar",waterIcon,null,48,-16,sx,sy-1)

			UpdatePoints()

				var/sx = 4,sy = 19
				var/string = "<b><i>Score: [score]"

				var/obj/HUDObj/O = AddHUD("BackScore",null,null,2,-2,sx,sy,HUD_LAYER)
				O.maptext = "<font color=black face=Tahoma size=1>[string]"

				O = AddHUD("ForeScore",null,null,0,0,sx,sy,HUD_LAYER+10)
				O.maptext = "<font color=yellow face=Tahoma size=1>[string]"
