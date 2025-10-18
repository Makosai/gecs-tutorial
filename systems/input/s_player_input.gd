class_name PlayerInputSystem
extends System

func _init():
	self.name = "PlayerInputSystem"
	self.group = "input"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func query() -> QueryBuilder:
	# Optionally add .with_group("player")
	# but avoid using with_group() for performance reasons
	return q.with_all([C_Player, C_Input])

func process(entity: Entity, _delta: float) -> void:
	# Capture and release mouse mode
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	var input := entity.get_component(C_Input) as C_Input
	input.move_vector = Vector3.ZERO
	input.jump = false
	input.cast_spell = false

	# Capture movement input
	if Input.is_action_pressed("move_forward"):
		input.move_vector.z -= 1
	if Input.is_action_pressed("move_back"):
		input.move_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input.move_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input.move_vector.x += 1

	# Normalize so diagonal isn't faster
	input.move_vector = input.move_vector.normalized()

	# Jump
	input.jump = Input.is_action_just_pressed("jump")

	# Spell cast
	input.cast_spell = Input.is_action_just_pressed("cast_spell")
