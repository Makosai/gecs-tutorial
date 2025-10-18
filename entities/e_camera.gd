@tool
class_name ThirdPersonCamera
extends Entity

func define_components() -> Array:
	return [
		C_Camera.new(),
		C_CameraState.new(),
		C_CameraTarget.new(),
		C_Transform.new(self.global_transform),
	]

func on_ready():
	add_to_group("camera")
	if has_component(C_Transform):
		var c_trs = get_component(C_Transform)
		c_trs.transform = self.global_transform
