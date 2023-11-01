extends Node

enum GroupEnum
{
	UNKNOWN,
	PLAYER,
	SAVEABLE,
	TRANSITION_ZONE
}

func get_enum_from_string(property: String) -> GroupEnum:
	match property:
		"Player":
			return GroupEnum.PLAYER
		"Saveable":
			return GroupEnum.SAVEABLE
		"TransitionZone":
			return GroupEnum.TRANSITION_ZONE
	
	print_debug("Property ", property, " does not exist in group enum")
	return GroupEnum.UNKNOWN


func get_string_from_enum(groupEnum: Groups.GroupEnum) -> String:
	match groupEnum:
		GroupEnum.PLAYER:
			return "Player"
		GroupEnum.SAVEABLE:
			return "Saveable"
		GroupEnum.TRANSITION_ZONE:
			return "TransitionZone"
		
	print_debug("String not found for group enum propety: " + str(groupEnum))
	return ""
