extends Node

var object_save_id = "PlayerData"

@export var player_name: String = "DumbFace"
var zone_to_spawn_in: ZoneEnums.Zone = ZoneEnums.Zone.A
var load_in_zone: bool = false
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
		print("Adding temp creatures")
		available_creatures.append(tempCreature1)
		available_creatures.append(tempCreature2)
	
	
func get_creature_at_index(index: int) -> CreatureBase:
	if (index < available_creatures.size()):
		return available_creatures[index]
	else:
		return null


func capture_node_data():
	var save_data_dictionary: Dictionary = {
		player_name = self.player_name,
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
			slot_index = index_of_creature
		}
		
	
		#print("creature_data_dict: ", creature_data_dict)
		available_creatures_dict[creature.id] = creature_data_dict	
		
	save_data_dictionary["available_creatures"] = available_creatures_dict
	#print("save_data_dictionary: ", save_data_dictionary)
	
	return save_data_dictionary


func restore_node_data(data: Dictionary):
	#print("player_data: ", data)
	var player_name_data = data["player_name"]
	var creature_data: Dictionary = data["available_creatures"]
	print("player_name: ", player_name_data)	
	print("creature_data retrieved: ", creature_data)	
	
	for creature_key in creature_data.keys():
		
		var loaded_creature: Dictionary = creature_data[creature_key]
		print("loaded_creature: ", loaded_creature)
		var creature: CreatureBase = CreatureBase.new()
		creature.id = creature_key
		print("creature_id = ", creature_key)
		creature.name = loaded_creature["name"]
		print("creature name = ", loaded_creature["name"])
		var slot_index: int = loaded_creature["slot_index"]
		print("slot_index = ", slot_index)
		available_creatures[slot_index] = creature


func get_object_save_id():
	return object_save_id
