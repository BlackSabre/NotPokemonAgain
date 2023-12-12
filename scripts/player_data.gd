extends Node

@export var player_name: String = "DumbFace"

var object_save_id = "PlayerData"
var zone_to_spawn_in: ZoneEnums.Zone = ZoneEnums.Zone.A
var load_in_zone: bool = false
var current_route: Routes.Route = Routes.Route.UNKNOWN
var last_world_position: Vector2
var last_world_scene_path: String
var stored_creatures: Array[CreatureBase] # creatures in player storage
var available_creatures: Array[CreatureBase] # creatures in player inventory

var tempCreature1 = preload("res://resources/creatures/pink_creature.tres")
var tempCreature2 = preload("res://resources/creatures/red_creature.tres")

func _ready():
	# Allows this singletons data to be saved
	add_to_group(Groups.get_string_from_enum(Groups.GroupEnum.SAVEABLE))
	
	#SaveHandler.load_game()
	
	#for debugging & dev
	if available_creatures.is_empty():
		print_debug("Adding temp creatures")
		available_creatures.append(tempCreature1)
		available_creatures.append(tempCreature2)
	
	
func get_creature_at_index(index: int) -> CreatureBase:
	if (index < available_creatures.size()):
		return available_creatures[index]
	else:
		return null


func get_first_creature() -> CreatureBase:
	return get_creature_at_index(0)


func capture_node_data() -> Dictionary:
	var save_data_dictionary: Dictionary = {
		player_name = self.player_name,
		current_route = self.current_route,
		last_world_position = self.last_world_position,
		last_world_scene_path = self.last_world_scene_path,
		available_creatures = null
	}
	
	if available_creatures.size() <= 0:
		print_debug("No creatures in PlayerData to save")
		return save_data_dictionary
	
	var available_creatures_dict: Dictionary = {}
	
	var index_of_creature: int = -1
	
	for creature in available_creatures:
		index_of_creature += 1
		var creature_data_dict: Dictionary = {
			name = creature.name,
			nickname = creature.nickname,
			front_sprite = creature.front_sprite.resource_path,
			base_attack = creature.base_attack,
			base_health = creature.base_health,
			level = creature.level,
			slot_index = index_of_creature
		}
		
	
		#print_debug("creature_data_dict: ", creature_data_dict)
		available_creatures_dict[creature.id] = creature_data_dict	
		
	save_data_dictionary["available_creatures"] = available_creatures_dict
	#print_debug("save_data_dictionary: ", save_data_dictionary)
	
	return save_data_dictionary


func restore_node_data(data: Dictionary) -> void:
	#print_debug("player_data: ", data)
	player_name = data["player_name"]
	current_route = data["current_route"]
	last_world_position = data["last_world_position"]
	last_world_scene_path = data["last_world_scene_path"]
	var creature_data: Dictionary = data["available_creatures"]
	
	for creature_key in creature_data.keys():		
		var loaded_creature: Dictionary = creature_data[creature_key]
		#print_debug("loaded_creature: ", loaded_creature)
		var creature: CreatureBase = CreatureBase.new()
		var slot_index: int = loaded_creature["slot_index"]
		
		creature.id = creature_key
		creature.name = loaded_creature["name"]
		creature.nickname = loaded_creature["nickname"]
		creature.front_sprite = load(loaded_creature["front_sprite"])
		creature.base_attack = loaded_creature["base_attack"]
		creature.base_health = loaded_creature["base_health"]
		creature.level = loaded_creature["level"]		
		available_creatures[slot_index] = creature


func get_object_save_id() -> String:
	return object_save_id
	
	
func get_current_route() -> Routes.Route:
	return current_route


func get_last_world_position() -> Vector2:
	return last_world_position


func get_last_world_scene_path() -> String:
	return last_world_scene_path


func set_current_route(route: Routes.Route) -> void:
	current_route = route


func set_last_world_position(position: Vector2) -> void:
	last_world_position = position


func set_last_world_scene_path(scene_path: String) -> void:
	last_world_scene_path = scene_path
