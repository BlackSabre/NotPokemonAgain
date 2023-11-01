class_name TallGrass extends Area2D

@export var route_location: Routes.Route = Routes.Route.Unknown

signal player_entered_tall_grass(route_location)

func _on_body_entered(_body):
	if (_body is Player):		
		player_entered_tall_grass.emit(route_location)
		
	if ($AnimationPlayer.is_playing() == false):
		$AnimationPlayer.play("tall_grass_move")
