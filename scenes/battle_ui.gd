class_name BattleUI extends Control

signal continue_text_primary_action
signal text_finished
signal on_creature_attack(attacker: CreatureForBattle, move: MoveBase, target: CreatureForBattle)

@onready var screen_effects: ScreenEffects = $"../ScreenEffects"
@onready var player_creature_node: CreatureForBattle = $UICanvas/PlayerCreature
@onready var enemy_creature_node: CreatureForBattle = $UICanvas/EnemyCreature
#@onready var player_creature_sprite: Sprite2D = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerSprite
#@onready var player_creature_name_text: RichTextLabel = $UICanvas/PlayerCreatureName
#@onready var player_creature_level_text: RichTextLabel = $UICanvas/PlayerCreatureLevel
#@onready var player_creature_health_bar: TextureProgressBar = $UICanvas/HealthBarPlayer
#@onready var enemy_creature_sprite: Sprite2D = $UICanvas/PlayerDialogueAndOptionsPanel/EnemySprite
#@onready var enemy_creature_name_text: RichTextLabel = $UICanvas/EnemyCreatureName
#@onready var enemy_creature_level_text: RichTextLabel = $UICanvas/EnemyCreatureLevel
#@onready var enemy_creature_health_bar: TextureProgressBar = $UICanvas/HealthBarEnemy
@onready var player_fight_buttons: PlayerFightButtonsContainer = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/PlayerFightButtons
@onready var move_buttons: MoveButtonsContainer = $UICanvas/PlayerDialogueAndOptionsPanel/PlayerOptionsMarginContainer/MoveButtons
@onready var dialog_text_label: RichTextLabel = $UICanvas/PlayerDialogueAndOptionsPanel/DialogueMarginContainer/RichTextLabel
@onready var player_dialogue_and_options_panel: PlayerDialogueAndOptionsPanel = $UICanvas/PlayerDialogueAndOptionsPanel

var time_per_character: float = 0.1#0.01
var is_writing_text: bool = false
var skip_current_text: bool = false
var skip_intro_text: bool = true

func _ready() -> void:
	var enemy_creature: CreatureForBattle = BattleSceneController.get_enemy_creature_node()
	
	player_dialogue_and_options_panel.connect("on_shrink_finished", _on_player_dialogue_and_options_panel_shrunk)	
	player_dialogue_and_options_panel.on_expand_finished.connect(_on_player_dialogue_and_options_panel_expanded)
	move_buttons.any_move_button_pressed.connect(_on_move_button_pressed)
	
	setup_creatures_ui()	
	
	var intro_dialogue_and_action_array: Array[DialogueAndActions] = []
	var dialogue_and_action_1: DialogueAndActions = DialogueAndActions.new()
	var dialogue_and_action_2: DialogueAndActions = DialogueAndActions.new()
	dialogue_and_action_1.message = "A wild " + enemy_creature.creature.name + " has appeared before you!"
	dialogue_and_action_2.message = "It doesn't look like it's here to chat..."
	#dialogue_and_action_2.add_event(finish_text_writing)
	intro_dialogue_and_action_array.append(dialogue_and_action_1)
	intro_dialogue_and_action_array.append(dialogue_and_action_2)
	
	if !skip_intro_text:
		await display_rich_text(dialog_text_label, intro_dialogue_and_action_array)
		finish_text_writing()
	else:
		dialog_text_label.clear()
		finish_text_writing()
	
	connect_signals_to_battle_scene_controller()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		if is_writing_text == true:
			skip_current_text = true
		else:	
			continue_text_primary_action.emit()


func finish_text_writing() -> void:
	dialog_text_label.clear()
	player_dialogue_and_options_panel.shrink_dialogue()	


func display_rich_text(text_container: RichTextLabel, dialogue_and_action_array: Array[DialogueAndActions]) -> void:
	for dialogue_and_action in dialogue_and_action_array:
		print_debug("Printing next message")
		skip_current_text = false
		is_writing_text = true
		text_container.clear()
		text_container.add_text("[color=transparent]" + dialogue_and_action.message + "[/color]")
		
		var index: int = 0
		
		for character in dialogue_and_action.message:
			#print_debug("skip_current_text: ", skip_current_text)
			if skip_current_text:
				skip_current_text = false
				print_debug("skipped text")
				break
				
			var text_to_show: String = "[color=white]" + dialogue_and_action.message.substr(0, index) + "[/color]"
			var text_to_hide: String = "[color=transparent]" + dialogue_and_action.message.substr(index) + "[/color]"
			text_container.text = text_to_show + text_to_hide
			index += 1
			await get_tree().create_timer(time_per_character).timeout		
			
		text_container.text = dialogue_and_action.message
		is_writing_text = false		
		
		dialogue_and_action.run_events()
		
		await continue_text_primary_action
	
	text_container.clear()
	text_finished.emit()


func _on_player_dialogue_and_options_panel_shrunk() -> void:
	player_fight_buttons.show_player_fight_buttons()


func _on_player_dialogue_and_options_panel_expanded() -> void:
	print_debug("Finsihed expanding")
	pass


func _on_attack_button_pressed() -> void:
	player_fight_buttons.hide_player_fight_buttons()
	player_fight_buttons.visible = false
	move_buttons.setup_move_buttons()
	await get_tree().create_timer(.1).timeout	
	move_buttons.show_move_buttons()


func setup_creatures_ui() -> void:
	var player_creature: CreatureBase = BattleSceneController.get_player_creature()
	var enemy_creature: CreatureBase = BattleSceneController.get_enemy_creature()
	
	player_creature_node.set_creature_and_ui(player_creature, true)
	enemy_creature_node.set_creature_and_ui(enemy_creature)


func _on_move_button_pressed(move: MoveBase) -> void:
	var player_creature: CreatureForBattle = BattleSceneController.get_player_creature_node()
	var target_creature: CreatureForBattle = BattleSceneController.get_enemy_creature_node()
	
	print_debug("Player creature ", player_creature.creature.name, " is attacking ", target_creature.creature.name, " with the move ", move.move_name)
	
	move_buttons.hide_move_buttons()
	player_dialogue_and_options_panel.expand_dialogue()
	await player_dialogue_and_options_panel.on_expand_finished
	
	# dialogue box now open. Display message for attack
	var dialogue_and_action_array: Array[DialogueAndActions] = []
	var dialogue_and_action: DialogueAndActions = DialogueAndActions.new()	
	
	dialogue_and_action.message = player_creature.creature.name + " uses " + move.move_name + " on " + target_creature.creature.name
	#dialogue_and_action.add_event(func(): on_creature_attack.emit(player_creature, move, target_creature))
	#dialogue_and_action.add_event(func(): screen_effects.shake_screen())
	dialogue_and_action.add_event(func() -> void: await process_attack(player_creature, move, target_creature))
	dialogue_and_action_array.append(dialogue_and_action)
	display_rich_text(dialog_text_label, dialogue_and_action_array)
	
	


func process_attack(player_creature: CreatureForBattle, move: MoveBase, target_creature: CreatureForBattle) -> void:
	on_creature_attack.emit(player_creature, move, target_creature)
	screen_effects.shake_screen()
	target_creature.process_action(move)
	await screen_effects.finished_shaking
	await enemy_creature_node.finished_animating
	
	if enemy_creature_node.is_dead():
		print_debug("the freaking thing is dead! Display a message")
		var dialogue_and_action_array: Array[DialogueAndActions] = []
		var dialogue_and_action: DialogueAndActions = DialogueAndActions.new()
		dialogue_and_action.message = target_creature.creature.name + " has been utterly defeated."
		dialogue_and_action_array.append(dialogue_and_action)
		display_rich_text(dialog_text_label, dialogue_and_action_array)
	
	
	text_finished.emit()
	
	do_enemy_turn()

func do_enemy_turn() -> void:
	var enemy_moveset: CreatureMovesetBase = enemy_creature_node.creature.moveset
	var valid_moves: Array[MoveBase] = enemy_moveset.get_valid_moves()	
	var enemy_move: MoveBase = valid_moves.pick_random()
	
	var dialogue_and_action_array: Array[DialogueAndActions] = []
	var dialogue_and_action: DialogueAndActions = DialogueAndActions.new()
	dialogue_and_action.message = player_creature_node.creature.name + " is being attacked"
	dialogue_and_action_array.append(dialogue_and_action)	
	display_rich_text(dialog_text_label, dialogue_and_action_array)


# Since the autoload script battle_scene_controller is instantiated before this node, 
# we have to use this method to connect the signals correctly.
func connect_signals_to_battle_scene_controller() -> void:
	BattleSceneController.connect_battle_ui_signals()
