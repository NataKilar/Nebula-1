/datum/controller/subsystem/mapping


/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()

	// Load our maps dynamically.
	log_world("using map is [global.using_map] default levels is: [english_list(global.using_map.default_levels)]")
	for(var/z in global.using_map.default_levels)
		var/map_file = global.using_map.default_levels[z]
		if(SSpersistence.SaveExists() && (text2num(z) in SSpersistence.saved_levels))
			// Load a default map instead.
			INCREMENT_WORLD_Z_SIZE
			continue
		log_world("attempting to load [map_file] in z [z]")
		maploader.load_map(map_file, 1, 1, text2num(z), no_changeturf = TRUE)
		CHECK_TICK

	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	report_progress("Loading world save.")
	
	SSpersistence.LoadWorld()
	
	// Initialize the overmap for Persistence.
	if(global.using_map.use_overmap)
		if(!global.using_map.overmap_z)
			build_overmap() // If a overmap hasn't been loaded, create a new one.

	// Generate the areas of the overmap that are hazardous.
	// Map is placed at the lower left corner of the overmap, not including the edges (2, 2).
	new /datum/random_map/automata/overmap(null, 2, 2, global.using_map.overmap_z, global.using_map.overmap_size - 2, global.using_map.overmap_size - 2, FALSE, FALSE, FALSE)
	
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

/datum/map
	var/list/default_levels
	var/overmap_seed = "overmapseed"

/obj/overmap_area_saver
	name = "Overmap Area Saver"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	invisibility = INVISIBILITY_ABSTRACT
	var/area/overmap_area

/obj/overmap_area_saver/Initialize()
	. = ..()
	overmap_area = locate(/area/overmap)