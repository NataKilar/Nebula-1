// Override event generation to ensure that events only get randomly placed on unsaved turfs.
/decl/overmap_event_handler/create_events(var/z_level, var/overmap_size, var/number_of_events)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/candidate_turfs = list()

	for(var/turf/T in block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level),locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE,z_level)))
		if(istype(T, /turf/unsimulated/map/hazardous))
			candidate_turfs |= T

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/overmap_event_type = pick(subtypesof(/datum/overmap_event))
		var/datum/overmap_event/datum_spawn = new overmap_event_type

		var/list/event_turfs = acquire_event_turfs(datum_spawn.count, datum_spawn.radius, candidate_turfs, datum_spawn.continuous)
		candidate_turfs -= event_turfs

		for(var/event_turf in event_turfs)
			var/type = pick(datum_spawn.hazards)
			new type(event_turf)

		qdel(datum_spawn)

/obj/effect/overmap/event/meteor
	var/decl/asteroid_class/class // Determines material make up of asteroid when using the asteroid magnet.
	var/spent = FALSE			  // Whether or not the asteroid field has been harvested yet.
	
/obj/effect/overmap/event/meteor/Initialize()
	. = ..()
	if(!class)
		class = pick(decls_repository.get_decls_of_subtype(/decl/asteroid_class/))

/decl/asteroid_class/
	var/name = "Space Rock"
	var/desc = "A standard, boring space rock."
	var/rock_type = /turf/simulated/wall/natural/asteroid // What the majority of the asteroid will be made out of.
	var/mineral_type = /turf/simulated/wall/natural/random/asteroid // What the minerals in the asteroid will be.

/decl/asteroid_class/asteroid
	name = "Asteroid"
	desc = "Silicate dense remnants of would-be planets. Rich in metals and other materials of industrial use."
	rock_type = /turf/simulated/wall/natural/asteroid
	mineral_type = /turf/simulated/wall/natural/random/asteroid

/decl/asteroid_class/comet
	name = "Comet"
	desc = "Icy balls of dust formed from beyond the system's frostline. Often contains rare volatiles and unusual chemicals trapped within their ice."
	rock_type = /turf/simulated/wall/natural/comet
	mineral_type = /turf/simulated/wall/natural/random/comet