extends Node

class_name DialogueAndActions

var message: String
var event_array: Array[Callable] = [func() -> void: pass]
var has_default_pass_event_in_event_array: bool = true 

func run_events() -> void:
	if event_array == null:
		return
	
	for event in event_array:
		event.call()

func add_event(event: Callable) -> void:
	if has_default_pass_event_in_event_array:
		has_default_pass_event_in_event_array = false
		event_array.clear()
	
	event_array.append(event)
