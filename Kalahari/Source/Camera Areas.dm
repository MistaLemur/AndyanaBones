area
	var
		minx = 400
		maxx = 24000
		miny = 300
		maxy = 1300

	Entered(mob/m)
		if(m.camera)
			m.camera.minx = minx
			m.camera.maxx = maxx
			m.camera.miny = miny
			m.camera.maxy = maxy