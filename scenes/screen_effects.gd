extends Control

@export var colour_to_fade_to: Color
@export var fade_to_colour_time: float = 0.3
@export var fade_from_colour_time: float = 0.3

@onready var screen_colour_overlay: ColorRect =  $CanvasLayer/ScreenColourOverlay

var is_faded_in: bool = false

func _ready():
	screen_colour_overlay.visible = false
	screen_colour_overlay.modulate.a = 0
	screen_colour_overlay.color = colour_to_fade_to
	

func _process(_delta):
	if (Input.is_action_just_pressed("primary_action")):
		fade(true)
		
	if (Input.is_action_just_pressed("secondary_action")):
		fade(false)

# if fade_in is true, fades entires screen to colour specified in colour_to_fade_to in fade_to_colour_time seconds
# if fade_in is false, fades entires screen from colour set in screen_colour_overlay to 0 alpha in fade_from_colour_time seconds
func fade(fade_in_param: bool) -> bool:
	if (fade_in_param):
		return fade_in()
	else:
		return fade_out()


# fades screen to colour in colour_to_fade_to in fade_to_colour_time seconds
func fade_in() -> bool:
	screen_colour_overlay.visible = true
	if is_faded_in == true:
		return false
	
	is_faded_in = true
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(screen_colour_overlay, "modulate:a", 1, fade_to_colour_time)		
	return true

# shows screen from colour of screen_colour_overlay to 0 alpha in fade_from_colour_time seconds
func fade_out() -> bool:
	if is_faded_in == false:
		return false
	
	is_faded_in = false
	var fade_tween: Tween = create_tween()
	fade_tween.parallel()
	fade_tween.tween_property(screen_colour_overlay, "modulate:a", 0, fade_from_colour_time)
	fade_tween.tween_property(screen_colour_overlay, "visible", false, fade_from_colour_time)
	return true
