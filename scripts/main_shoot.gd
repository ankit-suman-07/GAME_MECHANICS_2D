extends Node2D

@onready var player: CharacterBody2D = $player
const GUN = preload("uid://dup4vihofivhj")
const SWORD = preload("uid://dh1p3v8dpmxxs")


var gun: Node2D = null
var sword: Node2D = null
var offset := 20  # distance from player in pixels
var last_dir := 1 # default facing right

func _process(delta: float) -> void:
	var dir = sign(player.velocity.x)  # -1, 0, +1

	# Update last_dir only when moving
	if dir != 0:
		last_dir = dir

	# Draw / holster gun
	if Input.is_action_just_pressed("draw_gun"):
		if sword:
			sword.queue_free()
		if gun == null:
			gun = GUN.instantiate()
			player.add_child(gun)
			
			# initial facing based on last direction
			gun.scale.x = last_dir
			gun.position = Vector2(offset * last_dir, -20)
		else:
			gun.queue_free()
			gun = null
	
	if Input.is_action_just_pressed("draw_sword"):
		if gun:
			gun.queue_free()
		if sword == null:
			sword = SWORD.instantiate()
			player.add_child(sword)
			
			# initial facing based on last direction
			sword.scale.x = last_dir
			sword.position = Vector2(offset * last_dir, -10)
		else:
			sword.queue_free()
			sword = null

	# Update gun position / direction if equipped
	if gun:
		gun.scale.x = last_dir
		gun.position.x = offset * last_dir
	
	if sword:
		sword.scale.x = last_dir
		sword.position.x = offset * last_dir
