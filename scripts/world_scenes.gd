extends Node

var test_world_scene: String = "res://scenes/test_world_scene.tscn"
var test_world_scene_2: String = "res://scenes/test_world_scene_2.tscn"

@export var world_scene_dict: = {
	WorldScene.test_world_scene_1: test_world_scene,
	WorldScene.test_world_scene_2: test_world_scene_2
}


enum WorldScene {
	test_world_scene_1,
	test_world_scene_2,
}


func get_scene_from_enum(world_scene : WorldScene) -> PackedScene:
	if world_scene_dict.has(world_scene):
		return load(world_scene_dict[world_scene])
	else:
		return null

