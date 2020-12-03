// Random map for creation of chunky asteroids and comets
/datum/random_map/automata/asteroid
	iterations = 5
	descriptor = "asteroid"
	wall_type = /turf/simulated/wall/natural
	floor_type = /turf/space
	
	var/list/ore_turfs = list()
	var/rich_type = /turf/simulated/wall/natural/random
	var/poor_type = /turf/simulated/wall/natural/random

/datum/random_map/automata/asteroid/get_appropriate_path(var/value)
	switch(value)
		if(DOOR_CHAR, EMPTY_CHAR, WALL_CHAR)
			return wall_type
		if(FLOOR_CHAR)
			return floor_type

/datum/random_map/automata/asteroid/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

// Distribute ore in the asteroid.
/datum/random_map/automata/asteroid/cleanup()
	var/tmp_cell
	for (var/x = 1 to limit_x)
		for (var/y = 1 to limit_y)
			tmp_cell = TRANSLATE_COORD(x, y)
			if (map[tmp_cell] == cell_dead_value)
				ore_turfs += tmp_cell

	game_log("PASGEN", "Found [ore_turfs.len] ore turfs.")
	var/ore_count = round(map.len/10)
	var/door_count = 0
	var/empty_count = 0
	while((ore_count>0) && (ore_turfs.len>0))

		if(!priority_process)
			CHECK_TICK

		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map[check_cell] = DOOR_CHAR  // Mineral block
			door_count += 1
		else
			map[check_cell] = EMPTY_CHAR // Rare mineral block.
			empty_count += 1
		ore_count--

	game_log("PASGEN", "Set [door_count] turfs to random minerals.")
	game_log("PASGEN", "Set [empty_count] turfs to high-chance random minerals.")
	return 1

/datum/random_map/automata/asteroid/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/thing in block(locate(origin_x, origin_y, origin_z), locate(limit_x, limit_y, origin_z)))
		var/turf/T = thing
		new_path = null
		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		switch (map[tmp_cell])
			if(DOOR_CHAR)
				new_path = poor_type
			if(EMPTY_CHAR)
				new_path = rich_type
			if(FLOOR_CHAR)
				new_path = floor_type
			if(WALL_CHAR)
				new_path = wall_type

		if (!new_path)
			continue

		num_applied += 1
		T.ChangeTurf(new_path)
		get_additional_spawns(map[tmp_cell], T)
		CHECK_TICK

	game_log("PASGEN", "Applied [num_applied] turfs.")

/datum/random_map/automata/cave_system/test
	iterations = 2

/datum/random_map/automata/cave_system/test3
	iterations = 3