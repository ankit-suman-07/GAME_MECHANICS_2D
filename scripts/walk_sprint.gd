extends Node2D

const SPRINT_SPEED = 4
const WALK_SPEED = 2
var speed = WALK_SPEED
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	if Input.is_action_pressed("walk_left"):
		position.x -= speed
	if Input.is_action_pressed("walk_right"):
		position.x += speed
	
