// Keep the stack from being destroyed if the head is destroyed.
/obj/item/organ/external/head/Destroy()
	for(var/obj/item/organ/internal/stack/S in internal_organs)
		if(owner)
			S.update_backup(owner)
		S.forceMove(get_turf(src))
		internal_organs -= S
	. = ..()
	