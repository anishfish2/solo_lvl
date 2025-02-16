extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Adjust as needed for your game
var floor_normal = Vector2(0, -1)

func _physics_process(delta: float) -> void:
	# Apply gravity when not on the floor.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle horizontal movement.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move the character (no parameters needed in Godot 4).
	move_and_slide()
	
	# Check collisions and reflect velocity if colliding with walls or the top.
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var col_normal = collision.get_normal()
		if col_normal != floor_normal:
			velocity = velocity.bounce(col_normal)
