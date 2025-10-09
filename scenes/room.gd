extends Node3D

@onready var world: World = $World

func _ready():
	ECS.world = world
	var player_crud_system = preload("res://systems/s_player_crud.gd").new()
	ECS.world.add_system(player_crud_system)

func _process(delta: float) -> void:
	world.process(delta)
