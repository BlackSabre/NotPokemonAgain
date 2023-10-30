extends Node2D

signal on_enemy_health_changed(old_value: float, new_value: float)

var enemy_health: int = 10
var player_health: int = 10
var playerCreature
var enemyCreature


func _on_attack_button_pressed():
	update_enemy_health(-1)
	
	
func update_enemy_health(amount_to_add: float) -> void:
	var old_enemy_health = enemy_health
	enemy_health += amount_to_add
	on_enemy_health_changed.emit(old_enemy_health, enemy_health)
	
