extends Node

@export var room_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(%PlayButton as Button).pressed.connect(_on_play_pressed)


func _on_play_pressed() -> void:
	if room_scene == null:
		print("`room_scene` is null.")
		return
	get_tree().change_scene_to_packed(room_scene)
