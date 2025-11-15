extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: CharacterBody2D
var last_direction := 1
var can_hit := true

func _ready() -> void:
	player = get_parent() as CharacterBody2D
	if player == null:
		push_warning("Sword could not find player in scene tree.")

func _process(delta: float) -> void:
	if player == null:
		return

	var direction := Input.get_axis("left", "right")

	# update last facing direction
	if direction != 0:
		last_direction = direction

	if Input.is_action_just_pressed("shoot") and can_hit:
		swing_sword()

func swing_sword() -> void:
	can_hit = false

	# A 45-degree swing in direction of player facing
	var angle := deg_to_rad(45) * last_direction

	rotate(angle)
	await get_tree().create_timer(0.1).timeout
	rotate(-angle)

	can_hit = true
