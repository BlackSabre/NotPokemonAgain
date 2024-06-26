extends Node

signal scene_loaded

func load_world_scene_from_enum(world_scene_enum: WorldScenes.WorldScene) -> void:
	var world_scene: PackedScene = WorldScenes.get_scene_from_enum(world_scene_enum)
	
	if world_scene == null:
		printerr("Unable to load world scene using ", str(world_scene_enum))
	
	get_tree().change_scene_to_packed(world_scene)


func load_world_scene_from_packed_scene(packed_scene: PackedScene) -> void:
	if packed_scene == null:
		printerr("Packed scene is null. Unable to load scene")
		return
	
	#SaveHandler.save_game()
	#await SaveHandler.finished_saving
	
	
	var fx: ScreenEffects = get_node("/root/TestWorldScene/ScreenEffects")
	#var fx = $ScreenEffects
	
	if fx == null:
		print_debug("fx is null")
	else :	
		fx.fade(true)
		await fx.finished_fading_in
		print_debug("Done")		
		
	get_tree().change_scene_to_packed(packed_scene)
	
	#get_tree().change_scene_to_packed(packed_scene)
	#get_tree().change_scene_to_file("res://scenes/test_world_scene_2.tscn")


func load_packed_scene_2(packed_scene: PackedScene, method_to_call: Callable, arg: Vector2):
	get_tree().change_scene_to_packed(packed_scene)
	await scene_loaded
	method_to_call.call(arg)

func load_world_scene_from_path(scene_path: String) -> void:
	get_tree().call_deferred("change_scene_to_file", scene_path)


func finished_scene_load():
	scene_loaded.emit()

func load_battle_scene() -> void:
	#await SaveHandler.finished_saving
	#await ScreenEff.finished_fading_in
	print_debug("Finished waiting for save")
