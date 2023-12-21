class_name LevelRange extends Resource

var min_allowed_level: int = 1
var max_allowed_level: int = 99

@export_range(1, 99) var min_level: int : 
	set = set_min_level

@export_range(1, 99) var max_level: int :
	set = set_max_level


func set_min_level(new_value: int) -> int:
	if new_value < min_allowed_level:
		return min_allowed_level
	return new_value


func set_max_level(new_value: int) -> int:
	if new_value > max_allowed_level:
		return max_allowed_level
	return new_value
