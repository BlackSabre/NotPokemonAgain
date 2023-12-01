extends Node2D

signal on_enemy_health_changed(old_value: float, new_value: float)

var enemy_health: int = 10
var player_health: int = 10
var playerCreature
var enemyCreature
#@onready var screen_effects = $UI/ScreenEffects
@onready var screen_effects = $ScreenEffects

func _ready():
	var first_player_creature = PlayerData.get_creature_at_index(0)
	screen_effects.set_screen_overlay_visibility(true)
	screen_effects.fade(false)	
	
	
func _on_attack_button_pressed():
	update_enemy_health(-1)
	
	
func update_enemy_health(amount_to_add: float) -> void:
	var old_enemy_health = enemy_health
	enemy_health += amount_to_add
	on_enemy_health_changed.emit(old_enemy_health, enemy_health)
	
