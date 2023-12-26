extends Node2D

signal on_creature_health_changed(creature: CreatureBase, old_health_value: float, new_health_value: float)

#var player_creature: CreatureBase
#var enemy_creature: CreatureBase
#@onready var screen_effects = $UI/ScreenEffects
@onready var screen_effects: ScreenEffects = $ScreenEffects


func _ready() -> void:
	#var first_player_creature: CreatureBase = PlayerData.get_creature_at_index(0)
	screen_effects.set_screen_overlay_visibility(true)
	screen_effects.fade(false)


func update_health(target: CreatureBase, health_to_add: int) -> void:
	var old_health: int = target.current_health
	target.current_health += health_to_add
	on_creature_health_changed.emit(target, old_health, target.current_health)
