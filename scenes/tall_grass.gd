class_name TallGrass extends Area2D

@export var route_location: Routes.Route = Routes.Route.UNKNOWN

signal player_entered_tall_grass(route_location: Routes.Route, player: Node2D)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(_body: Node2D) -> void:
	if (_body is Player):		
		player_entered_tall_grass.emit(route_location, _body)
		
	if (animation_player.is_playing() == false):
		animation_player.play("tall_grass_move")
