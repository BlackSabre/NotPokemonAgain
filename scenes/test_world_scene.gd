extends Node2D

@export var percent_chance_random_encounter: float = 5

signal on_scene_ready

@onready var tilemap = $TileMap
@onready var screen_effects = $ScreenEffects
@onready var player = $Player

var player_spawn_position: Vector2
var player_spawn_zone: ZoneEnums.Zone
var tall_grass_tiles : Array

func _ready():
	tall_grass_tiles = get_tree().get_nodes_in_group("Tall Grass")	
	
	for tile in tall_grass_tiles:
		tile.player_entered_tall_grass.connect(_on_player_entered_tall_grass)
	
	if PlayerData.load_in_zone:
		player.disable_camera_smoothing()
		spawn_player_in_zone()
		PlayerData.load_in_zone = false
		
	screen_effects.set_screen_overlay_visibility(true)
	screen_effects.fade(false)
	await screen_effects.finished_fading_in
	on_scene_ready.emit()
	

func _process(_delta):
	if (Input.is_action_just_pressed("primary_action")):
		handle_left_mouse_click()


func _on_player_entered_tall_grass(route: Routes.Route, body):
	var percent = randf()
	if percent <= (percent_chance_random_encounter / 100):
		if "disable_movement" in body:
			player.disable_movement()
		#screen_effects.fade(true)
		BattleSetupHandler.setup_random_encounter(route)		


func handle_left_mouse_click():
	#var path = get_tree().current_scene.scene_file_path
	#print_debug("Path: ", path)
	pass


func load_battle_scene():
	pass


func _on_ready():
	#print_debug("parent node ready. Moving player to zone: ", PlayerData.zone_to_spawn_in)
	pass

func spawn_player_in_zone() -> void:
	var transition_zones : Array = get_all_transition_zones()
	var spawn_zone
	
	for zone in transition_zones:
		if (zone.this_zone == PlayerData.zone_to_spawn_in):
			spawn_zone = zone
			break
		
	if spawn_zone == null:
		printerr("No spawn zone in current scene")
		return		
	
	player.global_position = spawn_zone.spawn_position
	await get_tree().create_timer(0.01).timeout
	player.enable_camera_smoothing()


func get_all_transition_zones() -> Array:
	return get_tree().get_nodes_in_group(Groups.get_string_from_enum(Groups.GroupEnum.TRANSITION_ZONE))
