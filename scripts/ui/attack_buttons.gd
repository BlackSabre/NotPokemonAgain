class_name MoveButtonsContainer extends GridContainer

signal any_move_button_pressed(move: MoveBase)

@onready var move_1_button: MoveButton = $Move1
@onready var move_2_button: MoveButton = $Move2
@onready var move_3_button: MoveButton = $Move3
@onready var move_4_button: MoveButton = $Move4


func _ready() -> void:
	hide_move_buttons()
	move_1_button.move_button_pressed.connect(_on_any_move_button_pressed)
	move_2_button.move_button_pressed.connect(_on_any_move_button_pressed)
	move_3_button.move_button_pressed.connect(_on_any_move_button_pressed)
	move_4_button.move_button_pressed.connect(_on_any_move_button_pressed)

func hide_move_buttons() -> void:
	move_1_button.disabled = true
	move_1_button.hide()
	move_2_button.disabled = true
	move_2_button.hide()
	move_3_button.disabled = true
	move_3_button.hide()
	move_4_button.disabled = true
	move_4_button.hide()
	visible = false


func show_move_buttons() -> void:
	visible = true
	setup_move_buttons()
	#move_1_button.disabled = false
	move_1_button.show()
	#move_2_button.disabled = false
	move_2_button.show()
	#move_3_button.disabled = false
	move_3_button.show()
	#move_4_button.disabled = false
	move_4_button.show()
	move_1_button.grab_focus()


func setup_move_buttons() -> void:
	var moveset: CreatureMovesetBase = BattleSceneController.get_player_creature_moveset()	
	
	setup_move_button(move_1_button, moveset.move1)
	setup_move_button(move_2_button, moveset.move2)
	setup_move_button(move_3_button, moveset.move3)
	setup_move_button(move_4_button, moveset.move4)


func setup_move_button(button: MoveButton, move: MoveBase = null) -> void:	
	if move == null:
		button.text = "N/A"
		button.disabled = true
		button.focus_mode = Control.FOCUS_NONE
		if "move" in button:
			button.move = null
		return
	
	button.focus_mode = Control.FOCUS_ALL
	button.disabled = false	
	button.text = move.move_name
	if "move" in button:
		button.move = move


func _on_any_move_button_pressed(move: MoveBase) -> void:
	any_move_button_pressed.emit(move)
	
