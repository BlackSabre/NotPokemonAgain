class_name Player extends CharacterBody2D

@export var object_save_id: String



@onready var scene_parent = get_node("../")
@onready var camera: Camera2D = $Camera2D
@onready var animation_tree: AnimationTree = $AnimationTree

const SPEED = 190.0

func _ready():
	if scene_parent == null || !scene_parent.has_signal("on_scene_ready"):
		print_debug("Parent scene, ", scene_parent.name, ", does not have on_scene_ready signal")
		
	enable_camera_smoothing()
	enable_movement()
	


func _process(_delta):
	if (Input.is_physical_key_pressed(KEY_Q)):
		pass
		#var creature = PlayerData.get_creature_at_index(1)
		#print_debug(creature.name)
	
	if (Input.is_action_just_pressed("save_temp")):
		SaveHandler.save_game()

	if (Input.is_action_just_pressed("load_temp")):
		SaveHandler.load_game()
	
	if (Input.is_action_just_pressed("quit_temp")):
		get_tree().quit()


func _physics_process(_delta):
	move_and_animate_player()


func move_and_animate_player() -> void:
	# input
	var direction = Input.get_vector("left", "right", "up", "down")	
	velocity = direction * SPEED
	
	if (velocity == Vector2.ZERO):
		animation_tree.get("parameters/playback").travel("idle")
	else:
		animation_tree.get("parameters/playback").travel("walk")
		animation_tree.set("parameters/idle/blend_position", velocity)
		animation_tree.set("parameters/walk/blend_position", velocity)
	
	move_and_slide()


func capture_node_data() -> Dictionary:
	#var player = self;
	
	var save_data_dictionary = {
		global_position = var_to_str(self.global_position)
	}
	
	return save_data_dictionary


func restore_node_data(data: Dictionary) -> void:
	#print_debug("player: ", data)
	for key in data.keys():
		self.set(key, str_to_var(data[key]))


func enable_camera_smoothing() -> void:
	camera.position_smoothing_enabled = true


func disable_camera_smoothing() -> void:
	camera.position_smoothing_enabled = false


func disable_movement():
	velocity = Vector2.ZERO
	animation_tree.get("parameters/playback").travel("idle")
	set_physics_process(false)


func enable_movement():
	set_physics_process(true)


func get_object_save_id():
	return object_save_id

