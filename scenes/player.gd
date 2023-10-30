class_name Player extends CharacterBody2D

@export var object_save_id: String

@onready var camera: Camera2D = $Camera2D

const SPEED = 190.0

func _ready():
	enable_camera_smoothing()

func _process(_delta):
	if (Input.is_physical_key_pressed(KEY_Q)):
		var creature = PlayerData.get_creature_at_index(1)
		print(creature.name)
	
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
		$AnimationTree.get("parameters/playback").travel("idle")
	else:
		$AnimationTree.get("parameters/playback").travel("walk")
		$AnimationTree.set("parameters/idle/blend_position", velocity)
		$AnimationTree.set("parameters/walk/blend_position", velocity)
	
	move_and_slide()


func capture_node_data():
	#var player = self;6
	
	var save_data_dictionary = {
		global_position = var_to_str(self.global_position)
	}
	
	return save_data_dictionary


func restore_node_data(data: Dictionary):
	#print("player: ", data)
	for key in data.keys():
		self.set(key, str_to_var(data[key]))
	
	
func enable_camera_smoothing() -> void:
	camera.position_smoothing_enabled = true


func disable_camera_smoothing() -> void:
	camera.position_smoothing_enabled = false

func get_object_save_id():
	return object_save_id
