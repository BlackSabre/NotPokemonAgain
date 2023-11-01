extends Node

var random_creature: CreatureBase = null

func _ready():
	pass
	#get_random_enemy_creature(Routes.Route.Route1)

func start_random_encounter(route: Routes.Route):
	var creature_to_encounter = get_random_enemy_creature(route)
	#print_debug("Generated ", creature_to_encounter.name, " in route ", Routes.Route.keys()[route])

func get_random_enemy_creature(route: Routes.Route):
	var enemies_in_route: Array[CreatureBase] = AllCreatures.get_all_creatures_in_route(route)
	
	if enemies_in_route.size() == 0:
		print_debug("Cannot find any creatures in route ", Routes.Route.keys()[route])
		return null

	#var random_index = randi() % enemies_in_route.size()
	var random_creature: CreatureBase = enemies_in_route.pick_random()

	if random_creature == null:
		print_debug("Failed to get random creature")
		return null
	
	return random_creature
