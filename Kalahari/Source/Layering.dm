/*

//Height Layering
0 - 1: PARALLAX BACKDROPS
1 - 2: BACKGROUND OBJECTS
2 - 3: FLOOR AND GROUND OBJECTS
3: MOBS
3 - 4: FOREGROUND OBJECTS
5: FOREGROUND PARALLAX
9000 : INTERFACE

*/

//A custom layering scheme is necessary because of how the layering works in a sidescroller environment

atom

	var
		lheight //layering height


	New()
		.=..()

		updateLayer()

	proc
		updateLayer()
			layer = lheight + y //subject to change
			////world<<"[src.type] UPDATE LAYER: [layer]"