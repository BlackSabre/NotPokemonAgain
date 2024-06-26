extends Node2D

@export var percent_chance_random_encounter: float = 5

signal on_scene_ready

@onready var tilemap: Node = $TileMap
@onready var screen_effects: ScreenEffects = $ScreenEffects
@onready var player: Player = $Player

const TIME_UNTIL_RANDOM_ENCOUNTERS_CAN_START: float = 0.5

var player_spawn_position: Vector2
var player_spawn_zone: ZoneEnums.Zone
var tall_grass_tiles : Array
var ignore_random_encounters: bool = true

func _init():
	ignore_random_encounters = true

func _ready() -> void:
	SceneLoader.finished_scene_load()
	tall_grass_tiles = get_tree().get_nodes_in_group("Tall Grass")	
	
	for tile: TallGrass in tall_grass_tiles:
		tile.player_entered_tall_grass.connect(_on_player_entered_tall_grass)
	
	if PlayerData.load_in_zone:
		player.disable_camera_smoothing()
		spawn_player_in_zone()
		PlayerData.load_in_zone = false		
		
	screen_effects.set_screen_overlay_visibility(true)
	screen_effects.fade(false)
	if screen_effects.is_fading:
		await screen_effects.finished_fading_out
	on_scene_ready.emit()
	player.set_physics_process(true)
	await get_tree().create_timer(TIME_UNTIL_RANDOM_ENCOUNTERS_CAN_START).timeout
	print_debug("now lets show some encounters")
	ignore_random_encounters = false
	

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("primary_action")):
		handle_left_mouse_click()


func _on_player_entered_tall_grass(route: Routes.Route, body: Node2D) -> void:
	if ignore_random_encounters:
		return
		
	var percent: float = randf()
	if percent <= (percent_chance_random_encounter / 100):
		if "disable_movement" in body:
			player.disable_movement()
		#screen_effects.fade(true)
		BattleSetupHandler.setup_random_encounter(route)		


func handle_left_mouse_click() -> void:
	#var path = get_tree().current_scene.scene_file_path
	#print_debug("Path: ", path)
	pass


func load_battle_scene() -> void:
	pass


func _on_ready() -> void:
	#print_debug("parent node ready. Moving player to zone: ", PlayerData.zone_to_spawn_in)
	pass

func spawn_player_in_zone() -> void:
	var transition_zones : Array = get_all_transition_zones()
	var spawn_zone: TransitionZone
	
	for zone: Node in transition_zones:
		var transition_zone: TransitionZone
		if zone is TransitionZone:
			transition_zone = zone
		
		if transition_zone == null:
			print_debug("This zone is not a transition zone.")
			continue
		
		if (transition_zone.this_zone == PlayerData.zone_to_spawn_in):
			spawn_zone = transition_zone
			break
		
	if spawn_zone == null:
		printerr("No spawn zone in current scene")
		return		
	
	player.global_position = spawn_zone.spawn_position
	await get_tree().create_timer(0.01).timeout
	player.enable_camera_smoothing()


func get_all_transition_zones() -> Array:
	return get_tree().get_nodes_in_group(Groups.get_string_from_enum(Groups.GroupEnum.TRANSITION_ZONE))
