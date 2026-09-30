extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

@onready var death_label = $CanvasLayer/Label
var is_dead = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Spike check
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("spikes"):
			die()
			break


func die() -> void:
	if is_dead:
		return
	is_dead = true
	set_physics_process(false)
	death_label.show()
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
