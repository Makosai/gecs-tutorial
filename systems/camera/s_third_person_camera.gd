class_name ThirdPersonCameraSystem
extends System

# This should be set/reset externally (e.g. in main.gd/room.gd)
var scroll_delta := 0

func _init():
	self.name = "ThirdPersonCameraSystem"
	self.group = "camera"

func query() -> QueryBuilder:
	return q.with_all([C_Transform, C_CameraState, C_CameraTarget]).with_group(["camera"])

func process(camera_entity: Entity, delta: float) -> void:
	var cam_state := camera_entity.get_component(C_CameraState) as C_CameraState
	var cam_target := camera_entity.get_component(C_CameraTarget) as C_CameraTarget
	var cam_transform := camera_entity.get_component(C_Transform) as C_Transform
	if not cam_state or not cam_transform or not cam_target:
		return

	var player_entity = cam_target.entity
	if not player_entity or not player_entity.has_component(C_Transform):
		return

	var player_transform := player_entity.get_component(C_Transform) as C_Transform

	# --- Handle input (orbit and zoom) ---
	var mouse_delta := Input.get_last_mouse_velocity()
	cam_state.yaw -= mouse_delta.x * 0.2 * delta
	cam_state.pitch = clampf(cam_state.pitch - mouse_delta.y * 0.2 * delta, cam_state.pitch_min, cam_state.pitch_max)

	# Use the zoom_delta from the input component
	if scroll_delta != 0:
		cam_state.distance = clampf(
			cam_state.distance - scroll_delta,
			cam_state.min_distance,
			cam_state.max_distance
		)
		scroll_delta = 0 # Reset after use

	# --- Calculate new camera position/orientation ---
	var yaw_rad := deg_to_rad(cam_state.yaw)
	var pitch_rad := deg_to_rad(cam_state.pitch)
	var offset := Vector3(
		cam_state.distance * sin(yaw_rad) * cos(pitch_rad),
		1 - cam_state.distance * sin(pitch_rad), # Invert Y for Godot's coordinate system
		cam_state.distance * cos(yaw_rad) * cos(pitch_rad)
	)

	var target_pos := player_transform.transform.origin + Vector3(0, 1.5, 0) # Slightly above the player
	var cam_pos := target_pos + offset
	var up := Vector3.UP

	var look_at_transform := Transform3D().looking_at(target_pos - cam_pos, up)
	look_at_transform.origin = cam_pos
	cam_transform.transform = look_at_transform

	# Sync ECS component to camera node transform
	camera_entity.global_transform = cam_transform.transform

func _unhandled_input(event):
	# Capture scroll wheel input for zooming
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll_delta += 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll_delta -= 1
