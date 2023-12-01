extends Control

var time_per_character = 0.01
@onready var attack_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/AttackButton
@onready var items_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/Items
@onready var change_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/Change
@onready var run_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/Run
@onready var dialog_text: RichTextLabel = $UICanvas/PlayerDialogueAndOptionsPanel/DialogueMarginContainer/RichTextLabel

func _ready():
	hide_player_option_buttons()
	var enemy_creature = BattleSceneController.enemy_creature
	
	#Below for debug
	if enemy_creature == null:
		print_debug("Could not find enemy_creature in BattleSceneController")
		var random_route: Routes.Route = generate_random_route()
		enemy_creature = BattleSetupHandler.get_random_enemy_creature(random_route)
		
	print_debug("random creature: " + enemy_creature.name)	
	var text_to_display: String = "A wild " + enemy_creature.name + " has appeared before you!"
	display_rich_text(dialog_text, text_to_display)


func hide_player_option_buttons():
	attack_button.hide()
	items_button.hide()
	change_button.hide()
	run_button.hide()


func show_player_option_buttons():
	attack_button.show()
	items_button.show()
	change_button.show()
	run_button.show()


func display_rich_text(text_container: RichTextLabel, text: String):
	text_container.clear()
	text_container.add_text("[color=transparent]" + text + "[/color]")
	
	var index: int = 0
	
	for i in text:
		var text_to_show: String = "[color=white]" + text.substr(0, index) + "[/color]"
		var text_to_hide: String = "[color=transparent]" + text.substr(index) + "[/color]"
		text_container.text = text_to_show + text_to_hide
		index += 1		
		await get_tree().create_timer(time_per_character).timeout

	text_container.text = text


# below function for debug, shouldn't be called normally
func generate_random_route() -> Routes.Route:		
	var routes = Routes.Route.keys()
	routes.remove_at(0) # first route always UNKNOWN
	var random_route = Routes.Route[routes.pick_random()]
	
	return random_route
