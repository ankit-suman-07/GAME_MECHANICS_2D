extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_move_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mechanics/main_move.tscn")


func _on_jump_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mechanics/main_wall_jump.tscn")


func _on_weapons_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mechanics/main_shoot.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
