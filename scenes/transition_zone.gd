class_name TransitionZone extends Area2D

#@export var scene_to_load: PackedScene
@export var scene_to_load_path: String
@export var this_zone: ZoneEnums.Zone
@export var next_zone: ZoneEnums.Zone

@onready var spawn_position_marker: Marker2D = $SpawnPosition # : Vector2 = $SpawnPosition.global_position

var spawn_position: Vector2

func _ready() -> void:
	#print_debug("This zones position is: ", spawn_position)
	spawn_position = spawn_position_marker.global_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print_debug("Load new scene")
	
		PlayerData.zone_to_spawn_in = next_zone
		PlayerData.load_in_zone = true		
		SceneLoader.load_world_scene_from_path(scene_to_load_path)

