class_name PlayerFightButtonsContainer extends GridContainer

@onready var attack_button: Button = $AttackButton
@onready var items_button: Button = $Items
@onready var change_button: Button = $Change
@onready var run_button: Button = $Run


func _ready() -> void:
	hide_player_fight_buttons()


func hide_player_fight_buttons() -> void:
	attack_button.disabled = true
	attack_button.hide()
	items_button.disabled = true
	items_button.hide()
	change_button.disabled = true
	change_button.hide()
	run_button.disabled = true
	run_button.hide()
	visible = false


func show_player_fight_buttons() -> void:
	attack_button.disabled = false
	attack_button.show()
	items_button.disabled = false
	items_button.show()
	change_button.disabled = false
	change_button.show()
	run_button.disabled = false
	run_button.show()
	visible = true
	attack_button.grab_focus()
