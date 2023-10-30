extends Area2D

class_name TallGrass

signal player_entered_tall_grass

func _on_body_entered(_body):
	if (_body is Player):
		
		player_entered_tall_grass.emit()
		
	if ($AnimationPlayer.is_playing() == false):
		$AnimationPlayer.play("tall_grass_move")
