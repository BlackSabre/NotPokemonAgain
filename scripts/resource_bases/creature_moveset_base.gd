extends Resource

class_name CreatureMovesetBase

@export var move_1: MoveBase
@export var move_2: MoveBase
@export var move_3: MoveBase
@export var move_4: MoveBase

func get_number_of_valid_moves() -> int:
	var number_valid_moves = 0
	
	if move_1 != null:
		number_valid_moves += 1
	
	if move_2 != null:
		number_valid_moves += 1
		
	if move_3 != null:
		number_valid_moves += 1
		
	if move_4 != null:
		number_valid_moves += 1
	
	return number_valid_moves

func get_valid_moves() -> Array[MoveBase]:
	var moves: Array[MoveBase] = []
	
	if move_1 != null:
		moves.append(move_1)
	
	if move_2 != null:
		moves.append(move_2)
		
	if move_3 != null:
		moves.append(move_3)
		
	if move_4 != null:
		moves.append(move_4)
	
	if moves.size() == 0:
		print_debug("No moves found for moveset: ", resource_path, "!")
	
	return moves
