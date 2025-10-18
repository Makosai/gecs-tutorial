extends Node3D

@onready var world: World = $World

func _ready():
	ECS.world = world
	world.entity_nodes_root = $World/Entities.get_path()
	world.system_nodes_root = $World/Systems.get_path()

	# Phase 1
	# var player_crud_system := preload("res://systems/s_player_crud.gd").new()
	# ECS.world.add_system(player_crud_system)

	# Phase 2
	print("Spawning player entity...")
	var player: Entity = preload("res://entities/e_player.tscn").instantiate() as Entity
	ECS.world.add_entity(player)
	var c_trs := player.get_component(C_Transform) as C_Transform
	if c_trs:
		c_trs.transform.origin = Vector3(0, 0.5, 0) # Start above ground
	print("Player entity spawned: ", player)

	# Spawn camera entity
	var camera: Entity = preload("res://entities/e_camera.tscn").instantiate() as Entity
	ECS.world.add_entity(camera)

	# Assign camera target programmatically
	var cam_target := camera.get_component(C_CameraTarget) as C_CameraTarget
	if cam_target:
		cam_target.entity = player

	var player_input_system := preload("res://systems/input/s_player_input.gd").new()
	ECS.world.add_system(player_input_system)

	var player_movement_system := preload("res://systems/gameplay/s_player_movement.gd").new()
	ECS.world.add_system(player_movement_system)

	var spell_cast_system := preload("res://systems/gameplay/s_spell_cast.gd").new()
	ECS.world.add_system(spell_cast_system)

	var spell_movement_system := preload("res://systems/gameplay/s_spell_movement.gd").new()
	ECS.world.add_system(spell_movement_system)

	var camera_system := preload("res://systems/camera/s_third_person_camera.gd").new()
	ECS.world.add_system(camera_system)

func _process(delta: float) -> void:
	# world.process(delta)
	world.process(delta, "input")
	world.process(delta, "gameplay")
	world.process(delta, "camera")
