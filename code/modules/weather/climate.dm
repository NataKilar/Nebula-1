// The 'default' weather for a planet with an atmosphere.
/decl/weather/calm
	name = "calm"
	desc = "The weather is calm and ordinary for the surroundings."
	
	transitions = list(
						/decl/weather/rain,
						/decl/weather/snow,
						/decl/weather/windy
	)

/decl/weather/calm/can_transition(datum/gas_mixture/atmosphere, base_precip)
	return TRUE

/decl/weather/windy
	name = "windy"
	desc = "It's especially windy for the surroundings."
	transitions = list(
						/decl/weather/calm,
						/decl/weather/windy/heavy
	)

/decl/weather/windy/affect_mob(mob/target, base_precip)
	. = ..()
	if(ishuman(target) && prob(5))
		var/mob/living/carbon/human/H = target
		for(var/bp in H.held_item_slots)
			var/datum/inventory_slot/inv_slot = H.held_item_slots[bp]
			var/obj/held_item = inv_slot?.holding
			if(held_item?.simulated && held_item.w_class <= ITEM_SIZE_SMALL && H.unEquip(inv_slot.holding))
				held_item.throw_at_random(FALSE, 7, 3)
				H.visible_message(SPAN_WARNING("\The [held_item] is blown out of [H]'s hand!"), SPAN_WARNING("The wind blows \the [held_item] out of your hands!"))