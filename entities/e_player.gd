@tool
class_name Player
extends Entity

func define_components() -> Array:
	return [
		C_Position.new(Vector3(0, 1, 0)),
		C_Health.new(100),
		C_Score.new(0),
		C_Xp.new(0),
	]

func on_ready():
	# Sync entity scene position to C_Position on spawn
	if has_component(C_Position):
		var c_pos = get_component(C_Position)
		c_pos.position = self.global_position
