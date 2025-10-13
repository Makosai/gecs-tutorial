class_name PlayerMovementSystem
extends System

const ROOM_LIMIT = 25
const MOVE_SPEED = 10.0
const ROTATE_SPEED = 12.0
const GRAVITY = -24.8
const JUMP_VELOCITY = 12.0

func _init():
	self.name = "PlayerMovementSystem"
	self.group = "gameplay"

func query() -> QueryBuilder:
	return q.with_all([C_Transform, C_Input]).with_group(["player"])

func process(entity: Entity, delta: float) -> void:
	var cbody := entity as Node as CharacterBody3D
	if not cbody or not (cbody is CharacterBody3D):
		return

	var c_transform := entity.get_component(C_Transform) as C_Transform
	var c_input := entity.get_component(C_Input) as C_Input
	if not c_transform or not c_input:
		return

	# --- Get the camera's yaw from the camera entity ---
	var camera_entity := ECS.world.query.with_all([C_CameraState]).with_group(["camera"]).execute_one()
	var yaw := 0.0
	if camera_entity:
		var cam_state = camera_entity.get_component(C_CameraState)
		yaw = deg_to_rad(cam_state.yaw) # convert to radians if stored in degrees

	# --- Camera-relative movement vector ---
	var input_vec := Vector3(c_input.move_vector.x, 0, c_input.move_vector.z)
	var move_vec := input_vec.rotated(Vector3.UP, yaw)
	var velocity := cbody.velocity

	# Gravity and jumping
	if cbody.is_on_floor():
		if c_input.jump:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = 0.0
	else:
		velocity.y += GRAVITY * delta

	# Movement (XZ)
	var move_dir := move_vec.normalized()
	velocity.x = move_dir.x * MOVE_SPEED
	velocity.z = move_dir.z * MOVE_SPEED

	# --- Smoothly rotate to face movement direction ---
	if move_dir.length() > 0.01:
		var target_yaw := atan2(move_dir.x, move_dir.z)
		var current_yaw := cbody.rotation.y
		cbody.rotation.y = lerp_angle(current_yaw, target_yaw, delta * ROTATE_SPEED)
		cbody.rotation.x = 0
		cbody.rotation.z = 0

	cbody.velocity = velocity
	cbody.move_and_slide()

	# Sync ECS transform to node
	if c_transform:
		c_transform.transform = cbody.global_transform

	# Reset if out of bounds
	var pos := cbody.global_transform.origin
	if abs(pos.x) > ROOM_LIMIT or abs(pos.z) > ROOM_LIMIT or pos.y < -10:
		var new_pos := Vector3(0, 1, 0)
		var new_transform := cbody.global_transform
		new_transform.origin = new_pos
		cbody.global_transform = new_transform
		if c_transform:
			c_transform.transform = new_transform
		cbody.velocity = Vector3.ZERO
