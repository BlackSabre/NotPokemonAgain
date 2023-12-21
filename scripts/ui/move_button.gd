class_name MoveButton extends Button

signal move_button_pressed(move: MoveBase)

var move: MoveBase

func set_move(new_move: MoveBase) -> void:
	move = new_move


func get_move() -> MoveBase:
	return move


func _on_pressed() -> void:
	if (move == null):
		print_debug("No move found for button ", self.name)
		return
	
	print_debug("Move found for button ", self.name, " is ", move.move_name)
	move_button_pressed.emit(move)
