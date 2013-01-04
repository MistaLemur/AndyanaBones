/* Atom procs
	These procs expand on the basic built in procs.

	Bumped(O)
		Automatically called whenever a movable atom O Bump()s into src.
		Proc protype designed to be overridden for specific objects.

	Trigger(O)
		Automatically called whenever a movable atom O steps into the same
		turf with src.
		Proc protype designed to be overridden for specific objects.
*/

atom
	proc
		Bumped(O)
		// O just Bump()ed into src.
		// prototype Bumped() proc for all atoms

atom/movable
	proc
		Trigger(O)
		// O just stepped into the same space with src.
		// prototype Trigger() proc for all movable atoms.

	Bump(atom/A)
		if(istype(A)) A.Bumped(src)	// tell A that src bumped into it
		..()

turf
	Entered(O)
		for(var/atom/movable/A in contents - O)
			A.Trigger(O)	// tell A that O stepped on it
		..()