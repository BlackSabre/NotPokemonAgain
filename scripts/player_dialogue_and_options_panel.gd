class_name PlayerDialogueAndOptionsPanel extends Panel

signal on_shrink_finished
signal on_expand_finished

@onready var battle_ui_node: BattleUI = $"../.."

var shrink_time: float = 0.5
var expand_time: float = 0.5
var shrink_size_x: int = 316
var normal_size_x: int = 1152
var is_shrunk: bool = false


func _ready() -> void:
	#battle_ui_node.connect("text_finished", _on_intro_text_finished)
	pass


func _on_intro_text_finished() -> void:
	#print_debug("Intro text done")
	shrink_dialogue()


func shrink_dialogue() -> void:
	var shrink_tween: Tween = get_tree().create_tween()
	shrink_tween.tween_property(self, "size:x", shrink_size_x, shrink_time)
	shrink_tween.tween_callback(finished_shrinking)


func expand_dialogue() -> void:
	var expand_tween: Tween = get_tree().create_tween()
	expand_tween.tween_property(self, "size:x", normal_size_x, expand_time)
	expand_tween.tween_callback(finished_expanding)


func finished_shrinking() -> void:
	is_shrunk = true
	on_shrink_finished.emit()


func finished_expanding() -> void:
	is_shrunk = false
	on_expand_finished.emit()
