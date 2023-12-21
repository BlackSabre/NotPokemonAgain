class_name CreatureForBattle extends Node

signal finished_animating

@export var creature_sprite: Sprite2D
@export var health_bar: HealthBar
@export var name_text: RichTextLabel
@export var level_text: RichTextLabel

var creature: CreatureBase = null
var is_player_creature: bool = false
var is_animating: bool = false

# sets up the labels and such for the creature. The is_player_creature flag is for if the
# creature is the players, and as such should be setup a bit differently. 
func set_creature_and_ui(new_creature: CreatureBase, new_is_player_creature: bool = false) -> void:
	if (new_creature == null):
		print_debug("Creature cannot be set as it is null")
		return
	
	self.is_player_creature = new_is_player_creature
	creature = new_creature
	setup_ui()
	connect_signals()


func setup_ui() -> void:
	if (creature == null):
		print_debug("I can't set this up because there isn't a creature set! :/")
		return
	
	health_bar.max_value = creature.base_health
	health_bar.value = creature.current_health
	
	if is_player_creature:
		setup_ui_player_creature()
	else: 
		setup_ui_creature_default()


func process_action(move: MoveBase) -> void:
	var damage: float = move.damage
	
	process_damage(damage)
	
	#health_bar.update_health_visual()


# processes damage and plays animations.
func process_damage(damage: float) -> void:
	var new_health_value: float = clampf(creature.current_health, 0, creature.current_health - damage)
	health_bar.update_health_visual(new_health_value)
	await health_bar.finished_animating_health
	
	if new_health_value == 0:
		var death_tween: Tween = create_tween()
		death_tween.tween_property(creature_sprite, "position:y", 723, 1).set_trans(Tween.TRANS_CUBIC)


func setup_ui_creature_default() -> void:
	creature_sprite.texture = creature.front_sprite
	name_text.text = creature.name
	level_text.text = "Lvl " + str(creature.level)


func setup_ui_player_creature() -> void:
	creature_sprite.texture = creature.front_sprite
	name_text.text = "[right]" + creature.name + "[/right]"
	level_text.text = "[right] Lvl " + str(creature.level) + "[/right]"	


func is_dead() -> bool:
	return creature.current_health <= 0


func connect_signals() -> void:
	if !health_bar.finished_animating_health.is_connected(_on_health_finished_animating):
		health_bar.finished_animating_health.connect(_on_health_finished_animating)


func _on_health_finished_animating() -> void:
	finished_animating.emit()
	print_debug("Health has finished animating")
