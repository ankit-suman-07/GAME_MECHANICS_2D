extends CharacterBody2D

const BASE_SPEED := 300.0
const SPRINT_MULTIPLIER := 2.0
const JUMP_VELOCITY := -500.0
const MAX_JUMPS := 2

var speed := BASE_SPEED
var jumps_left := MAX_JUMPS
var was_on_wall := false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = MAX_JUMPS

	# Wall jump logic
	if is_on_wall():
		if not was_on_wall:
			jumps_left = 1  # only give once
		was_on_wall = true
	else:
		was_on_wall = false

	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		jumps_left -= 1
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED)

	if Input.is_action_pressed("sprint"):
		speed = BASE_SPEED * SPRINT_MULTIPLIER
	else:
		speed = BASE_SPEED

	# Dash
	if Input.is_action_just_pressed("dash"):
		velocity.x += direction * 1000  # make sane later

	move_and_slide()
