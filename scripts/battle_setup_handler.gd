extends Node

var battle_scene: PackedScene = preload("res://scenes/battle_scene.tscn")
var random_creature: CreatureBase = null


func setup_random_encounter(route: Routes.Route) -> void:
	var creature_to_encounter: CreatureBase = get_random_enemy_creature(route)
	PlayerData.set_current_route(route)
	SceneLoader.load_world_scene_from_packed_scene(battle_scene)
	BattleSceneController.start_random_encounter(creature_to_encounter)


func get_random_enemy_creature(route: Routes.Route) -> CreatureBase:
	var enemies_in_route: Array[CreatureBase] = AllCreatures.get_all_creatures_in_route(route)
	
	if enemies_in_route.size() == 0:
		print_debug("Cannot find any creatures in route ", Routes.Route.keys()[route])
		return null

	#var random_index = randi() % enemies_in_route.size()
	var new_random_creature: CreatureBase = enemies_in_route.pick_random()

	if new_random_creature == null:
		print_debug("Failed to get random creature")
		return null
	
	return new_random_creature
