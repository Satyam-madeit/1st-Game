extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position  # default spawn = starting spot

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Spike check
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("Spikes"):
			die()
		break

func set_checkpoint(pos: Vector2) -> void:
	spawn_position = pos

func die() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
