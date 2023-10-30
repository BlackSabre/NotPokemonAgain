extends Resource

class_name CreatureBase

@export var id: String
@export var name: String
@export var nickname: String
@export var front_sprite: Texture2D
@export var base_attack: int
@export var base_health: int
@export var level: int

var slot_index_on_trainer_or_player: int = -1
