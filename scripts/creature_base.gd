extends Resource

class_name CreatureBase

@export var id: String
@export var in_game_id: String
@export var name: String
@export var nickname: String
@export var front_sprite: Texture2D
@export var base_attack: int
@export var base_health: int
@export var level: int

# Don't need to save or load this. Just needs to be set in the inspector for each
# creature instance
@export var route_locations: Array[RouteAndLevelRange] 
