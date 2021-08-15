#define TURF_ATTEMPTS 5

SUBSYSTEM_DEF(weather)
	name = "Weather"
	wait = 1 SECOND

	var/list/weather_managers = list()
	var/list/weather_by_z = list()
	
	var/list/current_weathers = list()
	var/list/current_mobs = list()

/datum/controller/subsystem/weather/fire(resumed = FALSE)
	if(!resumed)
		current_weathers = weather_managers.Copy()
		current_mobs = living_mob_list_.Copy()

	while(current_weathers.len)
		var/datum/weather_manager/current = current_weathers[current_run.len]
		var/decl/weather/current_weather = GET_DECL(current.current_weather)
		current_run.len--
		if(!current_weather)
			continue
		var/list/z_levels = current.affected_sector ? current.affected_sector.map_z : current.affected_z.Copy()
		var/area/affected_area = current.external_area
		for(var/mob/living/L in living_mobs)
			if("[L.z]" in z_levels)
				current.add_image(L)
				if(isturf(L.loc) && get_area(L) == affected_area)
					current_weather.affect_mob(L, current.precipitation_mat)
				
			else
				current.remove_image(L)

/datum/controller/subsystem/weather/proc/add_weather_manager(datum/weather_manager/added)
	for(var/z in added.affected_z)
		if(z in weather_by_z)
			CRASH("Weather manager added for a z-level that already had an associated weather manager!")
		weather_by_z[z] = added
	weather_managers |= added

/datum/controller/subsystem/weather/proc/remove_weather_manager(datum/weather_manager/added)
	for(var/z in added.affected_z)
		weather_by_z -= z
	weather_managers -= added

#undef TURF_ATTEMPTS