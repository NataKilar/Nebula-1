#define STIRLING_HEAT_CAPACITY 300000

/obj/machinery/atmospherics/unary/stirling
	name = "stirling generator"
	desc = "A mechanical stirling generator. It generates power dependent on the temperature differential between input gas and a radiative heatsink."
	icon = 'icons/obj/power.dmi'
	icon_state = "stirling"
	layer = STRUCTURE_LAYER
	density = 1
	anchored = 1
	opacity = 1
	base_type = /obj/machinery/atmospherics/unary/stirling
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOPOWER | NOSCREEN

/obj/machinery/atmospherics/unary/stirling/Process()
	if(stat & BROKEN)
		return
	
	// Rather than having an internal gas mixture, the stirling generator uses its own temperature for the differential.
	var/turf/T = get_step(turn(dir, 180))
	if(istype(T, /turf/space))
		var/heat_change = get_thermal_radiation(temperature, 1, 1, SPACE_HEAT_TRANSFER_COEFFICIENT)
		ADJUST_ATOM_TEMPERATURE(src, temperature + (heat_change/STIRLING_HEAT_CAPACITY))
	

