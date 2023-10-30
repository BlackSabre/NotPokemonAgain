extends Node

func load_world_scene_from_enum(world_scene_enum: WorldScenes.WorldScene):
	var world_scene = WorldScenes.get_scene_from_enum(world_scene_enum)
	
	if world_scene == null:
		printerr("Unable to load world scene using ", str(world_scene_enum))
	
	get_tree().change_scene_to_packed(world_scene)

func load_world_scene_from_packed_scene(packed_scene: PackedScene):
	if packed_scene == null:
		printerr("Packed scene is null. Unable to load scene")
		return
		
	get_tree().change_scene_to_packed(packed_scene)
	
	#get_tree().change_scene_to_packed(packed_scene)
	#get_tree().change_scene_to_file("res://scenes/test_world_scene_2.tscn")

func load_world_scene_from_path(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
