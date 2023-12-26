extends Node

var creatures_folder_directory: String = "res://resources/creatures/"
var creatures_dict: Dictionary

func _ready() -> void:
	#print_debug("loading all creatures")
	var successfully_loaded_creatures: bool = load_all_creatures()
	if !successfully_loaded_creatures:
		print_debug("Failed to load creatures")
	#print_debug("finished loading all creatures: Success?: ", successfully_loaded_creatures)
	
	
func load_all_creatures() -> bool:
	creatures_dict.clear()
	var successfully_loaded_all_creatures: bool = true
	var creature_resources: PackedStringArray =  DirAccess.get_files_at(creatures_folder_directory)
	
	print_debug("creature_resources number: ", str(creature_resources.size()))
	
	if creature_resources.is_empty():
		printerr("Failed to get creatures in ", creatures_folder_directory, " or there are no creature_base resources available here")
		successfully_loaded_all_creatures = false
		
	for creature_resource_name: String in creature_resources:
		var creature: CreatureBase = load(creatures_folder_directory + "/" + creature_resource_name)
		
		if creature.id.is_empty():
			printerr("Creature ", creature_resource_name, " does not have an id")
			successfully_loaded_all_creatures = false
			continue
		
		if creature.in_game_id.is_empty():
			printerr("Creature ", creature_resource_name, " does not have an in-game id.")			
			successfully_loaded_all_creatures = false
			continue
		
		if creatures_dict.has(creature.id):
			printerr("Possible ID duplicate of creature ", creature_resource_name, 
				" with id ", creature.id, " and creature in dictionary ", 
				creatures_dict[creature.id].name)
			successfully_loaded_all_creatures = false
			continue
		
		creatures_dict[creature.in_game_id] = creature
		
	
	return successfully_loaded_all_creatures


func get_all_creatures_in_route(route: Routes.Route) -> Array[CreatureBase]:
	var creatures_in_route: Array[CreatureBase] = []
	#print_debug("Creatures in dictionary: ", creatures_dict.size())
	for creature: CreatureBase in creatures_dict.values():
		var route_locations_array: Array[RouteAndLevelRange] = creature.route_locations
		#print_debug("route_locations_array: ", route_locations_array)
		
		for route_location in route_locations_array:
			#print_debug("route_location: ", route_location.route)
			
			if route == route_location.route:
				creatures_in_route.append(creature)
				break;		
	
	var creature_list_string: String = ""
	for creature in creatures_in_route:
		if !creature_list_string.is_empty():
			creature_list_string += ", " + creature.name
		else:
			creature_list_string += creature.name
				
	#print_debug("Creatures in route: ", creature_list_string)
	return creatures_in_route
