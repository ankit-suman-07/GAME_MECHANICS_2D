extends StaticBody2D

@onready var gun: StaticBody2D = $"."
const BULLET = preload("uid://b34cpummgasq8")
@onready var marker_2d: Marker2D = $Marker2D

const BULLET_SPEED := 500.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		var bullet = BULLET.instantiate()
		
		# Add bullet to the world, not inside the gun
		get_tree().current_scene.add_child(bullet)
		
		# Position at gun muzzle (marker)
		bullet.global_position = marker_2d.global_position
		
		# Give it direction based on gun scale (left/right flip)
		var dir = sign(gun.scale.x)
		bullet.velocity = Vector2(BULLET_SPEED * dir, 0)
