//	Observer Pattern Implementation: World Saving
//		Registration type: /datum
//
//		Raised when: Persistence is starting the saving process for the world.
//
//		Arguments that the called proc should expect:
//		None

var/global/decl/observ/world_saving_start_event/world_saving_start_event = new

/decl/observ/world_saving_start_event
	name = "World Saving Start"
	expected_type = /datum

var/global/decl/observ/world_saving_finish_event/world_saving_finish_event = new

/decl/observ/world_saving_finish_event
	name = "World Saving Finish"
	expected_type = /datum