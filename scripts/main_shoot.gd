extends Node2D

@onready var player: CharacterBody2D = $player
const GUN = preload("uid://dup4vihofivhj")

var gun: Node2D = null
var offset := 20  # distance from player in pixels
var last_dir := 1 # default facing right

func _process(delta: float) -> void:
	var dir = sign(player.velocity.x)  # -1, 0, +1

	# Update last_dir only when moving
	if dir != 0:
		last_dir = dir

	# Draw / holster gun
	if Input.is_action_just_pressed("draw"):
		if gun == null:
			gun = GUN.instantiate()
			player.add_child(gun)
			
			# initial facing based on last direction
			gun.scale.x = last_dir
			gun.position = Vector2(offset * last_dir, -20)
		else:
			gun.queue_free()
			gun = null

	# Update gun position / direction if equipped
	if gun:
		gun.scale.x = last_dir
		gun.position.x = offset * last_dir
