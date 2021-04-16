/mob/living/carbon/death()
	if(stat & DEAD)
		return FALSE

	var/obj/item/organ/internal/stack/stack = switchToStack(src, mind)
	if(stack)
		// They did have a stack.
		to_chat(stack.stackmob, SPAN_NOTICE("Darkness envelopes you. Your character has died and you are now in limbo. Resleeve to continue playing as your character, or wait until a kind soul clones you from your cortical stack."))
	else
		// Check if they have *any* backups.
		if(length(get_valid_clone_pods(mind.unique_id))) // we have a backup.
			hide_fullscreens()
			var/mob/living/limbo/brainmob = new(src)
			brainmob.loc = null
			brainmob.SetName(real_name)
			brainmob.real_name = real_name
			brainmob.dna = dna.Clone()
			mind.transfer_to(brainmob)
			to_chat(brainmob, SPAN_NOTICE("Darkness envelopes you. Your character has died and you are now in limbo. Your sleeve has been destroyed but you still have backups in the world. Resleeve to continue playing as your character."))
		else if(ckey)
			var/mob/new_player/player = new()
			player.ckey = ckey
			to_chat(player, "The lack of a backup or stack means your character is dead for good. Create a new one to continue playing!")
	. = ..()

/mob/proc/resleeve()
	set category = "IC"
	set name = "Resleeve"

	if(ckey && mind)
		if(show_valid_respawns(src))
			verbs -= /mob/proc/resleeve
			verbs -= /mob/proc/death_give_up

/mob/proc/death_give_up()
	set category = "IC"
	set name = "Give up"
	if(key && mind)
		var/mob/new_player/player = new()
		player.ckey = ckey
		Destroy()
