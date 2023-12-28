class_name ScreenEffects extends CanvasLayer

const CANVAS_CAMERA_PATH: String = "/root/BattleScene/BattleUI/UICanvas"

signal finished_shaking()

# Fade settings
@export var colour_to_fade_to: Color
@export var fade_to_colour_time: float = 0.3
@export var fade_from_colour_time: float = 0.3
@onready var screen_colour_overlay: ColorRect = $ScreenColourOverlay

# Shake settings
var canvas_camera: CanvasLayer
# How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
@export var NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 9.0

@onready var rand: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var noise: FastNoiseLite = FastNoiseLite.new()
# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0
var shake_strength: float = 0.0
var SHAKE_STRENGTH_STOP_VALUE: float = 0.1
var original_canvas_camera_offset: Vector2

signal finished_fading_in
signal finished_fading_out

var is_fading: bool = false
var is_faded_in: bool = false
var is_shaking: bool = false

func _ready() -> void:
	is_faded_in = screen_colour_overlay.visible	
	if canvas_camera != null:
		original_canvas_camera_offset = canvas_camera.offset

	rand.randomize()
	# Randomise the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.frequency = 2
	

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("primary_action")):
		#fade(true)
		pass
		
	if (Input.is_action_just_pressed("secondary_action")):
		#fade(false)
		pass
	
	if is_shaking == false:
		return
	
	#print("Shake strength: " + str(shake_strength))
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
	
	# Shake by adjusting camera.offset so we can move the camera
	# around the level via its position
	canvas_camera.offset = get_noise_offset(delta)
	
	if shake_strength < SHAKE_STRENGTH_STOP_VALUE:		
		is_shaking = false;
		finished_shaking.emit()
		canvas_camera.offset = original_canvas_camera_offset


# if fade_in is true, fades entires screen to colour specified in colour_to_fade_to in fade_to_colour_time seconds
# if fade_in is false, fades entires screen from colour set in screen_colour_overlay to 0 alpha in fade_from_colour_time seconds
func fade(fade_in_param: bool) -> bool:	
	if is_fading:
		return false
		
	if fade_in_param:
		return await fade_in()
	else:
		return await fade_out()


# fades screen to colour in colour_to_fade_to in fade_to_colour_time seconds
func fade_in() -> bool:
	screen_colour_overlay.visible = true
	if is_faded_in == true:
		return false
	
	is_fading = true
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(screen_colour_overlay, "modulate:a", 1, fade_to_colour_time)
	await fade_tween.finished
	is_faded_in = true
	is_fading = false
	finished_fading_in.emit()
	#print_debug("Finished fading In")
	return true


# shows screen from colour of screen_colour_overlay to 0 alpha in fade_from_colour_time seconds
func fade_out() -> bool:
	if is_faded_in == false:
		return false
	
	is_fading = true
	var fade_tween: Tween = create_tween()
	fade_tween.parallel()
	fade_tween.tween_property(screen_colour_overlay, "modulate:a", 0, fade_from_colour_time)
	fade_tween.tween_property(screen_colour_overlay, "visible", false, fade_from_colour_time)
	await fade_tween.finished
	is_faded_in = false
	is_fading = false
	finished_fading_out.emit()
	#print_debug("Finished fading out")
	return true


func shake_screen() -> void:
	if canvas_camera == null:
		canvas_camera = get_node(CANVAS_CAMERA_PATH)
		
	shake_strength = NOISE_SHAKE_STRENGTH
	is_shaking = true


func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)

func set_screen_overlay_visibility(set_to_visible: bool) -> void:
	if set_to_visible:
		screen_colour_overlay.visible = true
		screen_colour_overlay.modulate.a = 1
	else:
		screen_colour_overlay.visible = false
		screen_colour_overlay.modulate.a = 0


func connect_signals_to_battle_scene_controller() -> void:
	pass
