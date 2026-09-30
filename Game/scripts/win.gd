extends Area2D

@onready var victory_label = $CanvasLayer/Label
var won := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Only the player counts (your tiles also trigger Areas)
	if won or not body is CharacterBody2D:
		return
	won = true
	body.set_physics_process(false)  # freeze Adam
	victory_label.show()
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/Start-UI.tscn")
