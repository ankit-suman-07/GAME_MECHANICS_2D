extends CharacterBody2D

# These constants act as the fundamental tuning knobs for movement.
# Keeping them at the top means gameplay balance can be adjusted without digging through code.
const BASE_SPEED := 300.0
const SPRINT_MULTIPLIER := 2.0
const JUMP_VELOCITY := -500.0
const MAX_JUMPS := 2
const CROUCH_SPEED_MULT := 0.5

# Runtime state variables controlling movement and abilities.
# 'speed' always starts at base speed, 'jumps_left' tracks double-jump logic,
# 'was_on_wall' helps detect wall-jump entry, and 'is_crouching' prevents double-shrinking.
var speed := BASE_SPEED
var jumps_left := MAX_JUMPS
var was_on_wall := false
var is_crouching := false


func _physics_process(delta: float) -> void:

	# Gravity is applied manually when the character isn’t grounded.
	# Resetting jumps on the floor restores double-jump capability.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = MAX_JUMPS


	# Wall-jump detection works by checking if the player has just touched a wall.
	# The moment wall contact begins, jumps_left is set to 1 exactly once,
	# which prevents infinite wall-jump refills while sliding.
	if is_on_wall():
		if not was_on_wall:
			jumps_left = 1
		was_on_wall = true
	else:
		was_on_wall = false


	# Standard jump: allowed only if a jump is available.
	# The vertical velocity is overwritten to create an instant upward impulse.
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		jumps_left -= 1
		velocity.y = JUMP_VELOCITY


	# Horizontal movement is driven directly by the “left”/“right” axis.
	# The velocity depends on the current speed value, which may be modified
	# later by sprinting or crouching.
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * speed


	# Sprinting is a simple speed swap. Holding the sprint button raises
	# movement speed; releasing it returns the character to normal movement.
	# Note: this change affects next-frame velocity since movement was calculated above.
	if Input.is_action_pressed("sprint"):
		speed = BASE_SPEED * SPRINT_MULTIPLIER
	else:
		speed = BASE_SPEED


	# Crouching works as a *hold* action.
	# The first time crouch is pressed, the player’s height is halved.
	# While crouching, movement slows by multiplying speed once per frame.
	# When released, the character returns to normal height.
	# Using a flag avoids repeated shrinking or expanding each frame.
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			scale.y *= 0.5         # Shrink once when entering crouch
			is_crouching = true
		speed *= CROUCH_SPEED_MULT  # Apply slow movement every frame while crouched
	else:
		if is_crouching:
			scale.y *= 2.0         # Restore original scale when leaving crouch
			is_crouching = false


	# Dash gives a burst of momentum in the current movement direction.
	# It's an instant horizontal shove added on top of existing velocity.
	# velocity_update
	if Input.is_action_just_pressed("dash"):
		velocity.x += direction * 1000


	# Hand off the velocity to Godot’s physics engine,
	# letting it handle collisions and sliding.
	move_and_slide()

# This script is a compact, state-driven 2D character controller that combines physics integration, input handling, and small gameplay rules into a single `_physics_process` loop. It starts by defining constants for base movement, sprint multiplier, jump impulse, maximum jumps and a crouch speed multiplier so the gameplay tuning values are obvious and centralized; `speed`, `jumps_left`, `was_on_wall`, and `is_crouching` are the run-time state variables that the code updates each frame. The gravity block (`if not is_on_floor(): velocity += get_gravity() * delta`) integrates vertical acceleration while resetting `jumps_left` when the character is grounded, which implements standard double-jump behavior by letting the player regain jumps on landing. The wall-jump helper (`was_on_wall`) detects the instant the character first touches a wall and sets `jumps_left = 1` so the player can perform a single wall jump without repeatedly refilling jumps while sliding along the wall. Jump input consumes one available jump and sets the vertical velocity to the negative `JUMP_VELOCITY`, producing an immediate upward impulse. Horizontal movement reads a directional axis (`Input.get_axis("left","right")`) and assigns `velocity.x = direction * speed` so lateral motion is directly driven by the current `speed` value; sprinting is represented by toggling the `speed` variable to `BASE_SPEED * SPRINT_MULTIPLIER` when the sprint button is held, which is intended to temporarily increase the player’s horizontal velocity. The crouch is implemented as a hold mechanic: when the crouch button is pressed the code halves the `y` scale once (guarded by `is_crouching`) and multiplies `speed` by `CROUCH_SPEED_MULT` to slow the player while crouched, and when released it restores the scale by multiplying by two and clears the `is_crouching` flag. A dash input gives a quick horizontal impulse by adding `direction * 1000` to `velocity.x`, and finally `move_and_slide()` hands the computed velocity to Godot’s physics for collision resolution and movement. Reason-wise, the script favors readability and explicit state flags over implicit tweaks: discrete flags (`is_crouching`, `was_on_wall`) make transitions deterministic, centralized constants make tuning easy, and single-point velocity assignments keep the physics predictable. A couple of practical caveats: altering `scale` can affect collision shapes (you may need to update or swap collision shapes when crouching), and because the code calculates `velocity.x` before updating `speed` for sprinting, the sprint change takes effect the next frame (moving the sprint check above the movement assignment would make sprinting instant). Overall this structure is straightforward to extend (animations, refined dash forces, toggled vs. held crouch) while keeping gameplay rules easy to reason about.
