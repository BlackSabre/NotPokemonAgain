extends Control

signal continue_text_primary_action


@onready var player_creature_sprite: Sprite2D = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerSprite
@onready var enemy_creature_sprite: Sprite2D = $UICanvas/PlayerDialogueAndOptionsPanel/EnemySprite
@onready var attack_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/AttackButton
@onready var items_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/Items
@onready var change_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/Change
@onready var run_button: Button = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerOptions/Run
@onready var dialog_text_label: RichTextLabel = $UICanvas/PlayerDialogueAndOptionsPanel/DialogueMarginContainer/RichTextLabel

var time_per_character: float = 0.1#0.01
var is_writing_text: bool = false
var skip_current_text: bool = false

func _ready():
	hide_player_option_buttons()
	var enemy_creature = BattleSceneController.enemy_creature
	
	#Below for debug
	if enemy_creature == null:
		print_debug("Could not find enemy_creature in BattleSceneController")
		var random_route: Routes.Route = generate_random_route()
		enemy_creature = BattleSetupHandler.get_random_enemy_creature(random_route)
		
	print_debug("random creature: " + enemy_creature.name)
	
	player_creature_sprite.texture = PlayerData.get_first_creature().front_sprite
	enemy_creature_sprite.texture = enemy_creature.front_sprite
	var text_to_display_array: Array[String]
	text_to_display_array.append("A wild " + enemy_creature.name + " has appeared before you!")
	text_to_display_array.append("Now to carry on")
	
	display_rich_text(dialog_text_label, text_to_display_array)


func _input(event):
	if event.is_action_pressed("primary_action"):
		if is_writing_text == true:
			skip_current_text = true
		else:	
			continue_text_primary_action.emit()


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


func display_rich_text(text_container: RichTextLabel, text_array: Array):
	for text in text_array:
		print_debug("Printing next message")
		skip_current_text = false
		is_writing_text = true
		text_container.clear()
		text_container.add_text("[color=transparent]" + text + "[/color]")
		
		var index: int = 0
		
		for i in text:
			#print_debug("skip_current_text: ", skip_current_text)
			if skip_current_text:
				skip_current_text = false
				print_debug("skipped text")
				break
				
			var text_to_show: String = "[color=white]" + text.substr(0, index) + "[/color]"
			var text_to_hide: String = "[color=transparent]" + text.substr(index) + "[/color]"
			text_container.text = text_to_show + text_to_hide
			index += 1
			await get_tree().create_timer(time_per_character).timeout

		text_container.text = text
		is_writing_text = false
		await continue_text_primary_action


#func display_rich_text(text_container: RichTextLabel, text: String):
	#is_writing_text = true
	#text_container.clear()
	#text_container.add_text("[color=transparent]" + text + "[/color]")
	#
	#var index: int = 0
	#
	#for i in text:
		#if skip_current_text:
			#skip_current_text = false
			#break
			#
		#var text_to_show: String = "[color=white]" + text.substr(0, index) + "[/color]"
		#var text_to_hide: String = "[color=transparent]" + text.substr(index) + "[/color]"
		#text_container.text = text_to_show + text_to_hide
		#index += 1
		#await get_tree().create_timer(time_per_character).timeout
#
	#text_container.text = text
	#is_writing_text = false


# below function for debug, shouldn't be called normally
func generate_random_route() -> Routes.Route:		
	var routes = Routes.Route.keys()
	routes.remove_at(0) # first route always UNKNOWN
	var random_route = Routes.Route[routes.pick_random()]
	
	return random_route
