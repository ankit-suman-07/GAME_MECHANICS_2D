extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -500.0
var can_jump = 2


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_jump = 2
	
	if Input.is_action_just_pressed("sprint"):
		SPEED += 300
	if Input.is_action_just_released("sprint"):
		SPEED = 300.0

	if Input.is_action_just_pressed("jump") and can_jump > 0:
		can_jump -= 1
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("dash"):
		position.x += 200.0 * direction

	move_and_slide()
