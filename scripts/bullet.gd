extends CharacterBody2D

#var velocity: Vector2

func _physics_process(delta):
	velocity = velocity
	move_and_slide()

	# Clean up off screen
	if global_position.x < -2000 or global_position.x > 2000:
		queue_free()
