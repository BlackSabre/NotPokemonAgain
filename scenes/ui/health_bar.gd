class_name HealthBar extends TextureProgressBar

signal finished_animating_health

@export var green_colour: Color
@export var yellow_colour: Color
@export var red_colour: Color
@export var health_divisor_for_yellow_health: int = 2
@export var health_divisor_for_red_health: int = 5

var reduce_health_time: float = 3
var is_animating: bool = false

func _process(_delta: float) -> void:
	if (!is_animating):
		return	
	
	if (value <= max_value / health_divisor_for_red_health):
		tint_progress = red_colour
	elif value <= max_value / health_divisor_for_yellow_health:
		tint_progress = yellow_colour
	else:
		tint_progress = green_colour


func update_health_visual(new_value: float) -> void:
	is_animating = true
	var health_tween: Tween = create_tween()
	health_tween.tween_property(self, "value", new_value, reduce_health_time).from(value)
	health_tween.tween_callback(finished_tweening)


func finished_tweening() -> void:
	is_animating = false
	finished_animating_health.emit()
