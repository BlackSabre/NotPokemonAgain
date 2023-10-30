extends TextureProgressBar

var reduce_health_time: float = 1

func _on_battle_scene_on_enemy_health_changed(old_value: float, new_value: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "value", new_value, reduce_health_time).from(old_value)
	#$".".value = new_value

func decrease_health_bar_visual():
	pass
