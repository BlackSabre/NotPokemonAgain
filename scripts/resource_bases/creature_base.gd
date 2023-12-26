extends Resource

class_name CreatureBase

signal health_changed(old_health_value: int, new_health_value: int)

@export var id: String
@export var in_game_id: String
@export var name: String
@export var nickname: String
@export var front_sprite: Texture2D
@export var base_attack: int
@export var base_health: int
@export var level: int
@export var moveset: CreatureMovesetBase
@export var current_xp: int
@export var base_xp_award: int

@export var current_health: int
@export var is_dead: bool = false

# Don't need to save or load this. Just needs to be set in the inspector for each
# creature instance
@export var route_locations: Array[RouteAndLevelRange] 


func update_health(health_to_add: int) -> void:
	var old_health: int = current_health
	current_health += health_to_add
	
	print_debug("Updating health. Current Health: ", current_health)
	
	if current_health <= 0:
		print_debug("Creature died in the creature base")
		current_health = 0
		is_dead = true
	
	if current_health > base_health:
		current_health = base_health
		
	health_changed.emit(old_health, current_health)


func full_heal() -> void:
	current_health = base_health
