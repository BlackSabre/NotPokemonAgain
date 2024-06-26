extends Node

const BASE_DIRECTORY: String = "res://"
const DIRECTORY: String = "saves"
const FILE_EXTENSION: String = ".json"

var file_name: String = "gameSave"
var is_saving: bool = false
var is_loading: bool = false

signal finished_saving

func save_game() -> bool:
	print_debug("saving game")
	if is_loading == true:
		printerr("Game is currently loading. Cannot save game.")
		return false
	
	is_saving = true
	var game_data_dict: Dictionary
	
	game_data_dict = add_currently_loaded_scene(game_data_dict)
	game_data_dict = add_all_save_nodes(game_data_dict)
	
	var json_string: String = JSON.stringify(game_data_dict)		
	
	var is_directory_okay: bool = check_and_create_directory_for_save(BASE_DIRECTORY, DIRECTORY)
	var save_path: String = BASE_DIRECTORY + DIRECTORY + "/" + file_name + FILE_EXTENSION
	
	if is_directory_okay == false:
		printerr("Error while opening/creating directory. Check previous log messages for details")	
	
	var save_game_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	
	save_game_file.store_line(json_string)
	
	if (save_game_file == null):
		printerr("Failed to save game to ", save_path)
		printerr("FileAccess open error: ", FileAccess.get_open_error())
		save_game_file.close()
		return false
	
	save_game_file.close()
	is_saving = false
	finished_saving.emit()
	print_debug("Game successfully finished saving")	
	return true


func load_game() -> bool:
	# load save file and check for errors
	print_debug("loading game")
	
	if is_saving == true:
		printerr("Game is currently saving. Cannot load game.")
		return false
	
	is_loading = true
	var load_path: String = BASE_DIRECTORY + DIRECTORY + "/" + file_name + FILE_EXTENSION
	var save_file: FileAccess = get_and_check_save_file(load_path)
	
	if save_file == null:
		return false
	
	# parse json and check for errors
	var json_data: JSON = JSON.new()	
	var json_parse_result: Error = json_data.parse(save_file.get_as_text())
	save_file.close()
	
	if json_parse_result != OK:
		printerr("Failed to parse json in save file. Error code: ", json_parse_result)
		return false
	
	var save_data_dict: Dictionary = json_data.get_data()	
	
	# load scene first
	var load_scene: PackedScene
	
	if save_data_dict.has("last_loaded_scene"):
		var scene_path: String = save_data_dict["last_loaded_scene"]
		print_debug("scene_path: ", scene_path)
		load_scene = load(scene_path)
	else:
		printerr("No scene found in save file.")
	
	SceneLoader.load_world_scene_from_packed_scene(load_scene)
	
	# need to defer the method call to load scene data as scene isn't available right
	# after change_scene_to_packed
	call_deferred("load_scene_objects", save_data_dict)
	return true


func load_last_scene_and_player_position() -> bool:
	print_debug("loading last scene and player position")
	
	if is_saving == true:
		printerr("Game is currently saving. Cannot load game.")
		return false
	
	is_loading = true
	var load_path: String = BASE_DIRECTORY + DIRECTORY + "/" + file_name + FILE_EXTENSION
	var save_file: FileAccess = get_and_check_save_file(load_path)
	
	if save_file == null:
		return false
	
	# parse json and check for errors
	var json_data: JSON = JSON.new()	
	var json_parse_result: Error = json_data.parse(save_file.get_as_text())
	save_file.close()
	
	if json_parse_result != OK:
		printerr("Failed to parse json in save file. Error code: ", json_parse_result)
		return false
	
	var save_data_dict: Dictionary = json_data.get_data()
	
	# load scene first
	var load_scene: PackedScene
	
	if save_data_dict.has("last_loaded_scene"):
		var scene_path: String = save_data_dict["last_loaded_scene"]
		var player_dict: Dictionary = save_data_dict["player"]
		var player_position: Vector2
		
		if player_dict.has("global_position"):
			player_position = str_to_var(player_dict["global_position"])
		else:
			print_debug("Player global position not found. Defaulting to Vector.zero ")
			player_position = Vector2.ZERO
			
		print_debug("scene_path: ", scene_path)
		print_debug("player_pos: ", player_position)
		load_scene = ResourceLoader.load(scene_path)
		#SceneLoader.load_world_scene_from_packed_scene(load_scene)
		SceneLoader.load_packed_scene_2(load_scene, load_player_position, player_position)
		#call_deferred("load_player_position", player_position)
		print_debug("load_scene: ", load_scene.get_state())
	else:
		printerr("No scene found in save file.")
	
	return true

# Gets the path of the currently loaded scene and adds it to game_data with the key
# "last_loaded_scene"
func add_currently_loaded_scene(game_data_dict: Dictionary) -> Dictionary:
	# save path of currently loaded scene
	var last_loaded_scene_path: String = get_tree().current_scene.scene_file_path
	
	if (last_loaded_scene_path.is_empty() or last_loaded_scene_path == null):
		printerr("Did not save current scene path.")
		return game_data_dict
	
	var last_loaded_scene_dict: Dictionary = { "last_loaded_scene": last_loaded_scene_path }
	game_data_dict.merge(last_loaded_scene_dict)
	
	#print_debug("Scene path successfully added. Scene path: ", last_loaded_scene_path)
		
	return game_data_dict


# Gets all nodes in the scene that are in the group that matches to Groups.GroupEnum.SAVEABLE
# and adds them to game_data and returns it
func add_all_save_nodes(game_data: Dictionary) -> Dictionary:
	# get all nodes we want to save. Should be in group SaveData
	var save_node_array: Array[Node] = get_tree().get_nodes_in_group(
		Groups.get_string_from_enum(Groups.GroupEnum.SAVEABLE)
	);
	
	# no nodes. Return false
	if save_node_array.is_empty():
		print_debug("No nodes to save")
	
	# call capture_node_data in each node in save group and add it to game_data
	for save_node: Node in save_node_array:
		if save_node.has_method("capture_node_data") == false:
			print_debug("Save node '", save_node.name,  "' is missing a capture_node_data function. Skipping...")
			continue
		
		if save_node.has_method("get_object_save_id") == false:
			print_debug("Node ", save_node.name, " does not have the method get_object_save_id(). Skipping...")
			continue
			
		var node_data_dict: Dictionary = {}
		@warning_ignore("unsafe_method_access") # already checking for method
		node_data_dict[save_node.get_object_save_id()] = save_node.capture_node_data()
		
		#print_debug("node_data_dict: ", node_data_dict)
		
		game_data.merge(node_data_dict)
	
	return game_data


func add_all_autoloads_data(_game_data: Array) -> void:
	pass


# loads the objects in the scene based on their save_ids and the keys in data_dict
func load_scene_objects(data_dict: Dictionary) -> void:
	var nodes_to_load: Array[Node] = get_tree().get_nodes_in_group(Groups.get_string_from_enum(Groups.GroupEnum.SAVEABLE))
	
	for node: Node in nodes_to_load:
		var node_save_id: String;
		
		if "get_object_save_id" in node:
			@warning_ignore("unsafe_method_access") # checking for method
			node_save_id = node.get_object_save_id()
		
		if node_save_id == "" || node_save_id == null:
			print_debug("No save id found for: ", node.name)
			continue
			
		if "restore_node_data" in node:
			if data_dict.has(node_save_id):
				@warning_ignore("unsafe_method_access") # checking for method
				node.restore_node_data(data_dict[node_save_id])	
	
	is_loading = false
	print_debug("Game successfully finished loading")	


# Validates the path at base_directory/directory. If directory does not exist, then this also 
# attempts to create it.
# If successfully validated/created, returns true
func check_and_create_directory_for_save(base_directory: String, directory: String) -> bool:
	var dir_access: DirAccess = DirAccess.open(directory)	
	
	if (dir_access == null):
		print_debug("Directory '", directory, "' does not exist. Attempting to create...")		
		dir_access = DirAccess.open(base_directory)
		
		if (dir_access == null):
			printerr("Could not open base directory, '", base_directory, "'. Game not saved.")
			return false

		dir_access.make_dir(directory)
		DirAccess.open(base_directory + directory + "/")
		
		if (dir_access == null):
			printerr("Failed create new folder at '", base_directory + directory,"' Game not saved")
		
	return true


func get_and_check_save_file(load_path: String) -> FileAccess:
	var save_file: FileAccess = FileAccess.open(load_path, FileAccess.READ)
	
	if save_file == null:
		save_file.close()
		printerr("Error loading save game at: ", load_path)
		printerr("FileAccess open error: ", FileAccess.get_open_error())
		return null
	
	return save_file


func load_player_position(player_position: Vector2) -> void:
	var player_node_array: Array[Node] = get_tree().get_nodes_in_group(Groups.get_string_from_enum(Groups.GroupEnum.PLAYER))	
	
	if player_node_array == null || player_node_array.size() == 0:
		printerr("Could not find player node for scene.")
		return
	
	var player_node = player_node_array[0]
	player_node.global_position = player_position	
	
	is_loading = false
	print_debug("Last player position has successfully completed")
