@tool
class_name Player
extends Entity

func define_components() -> Array:
	return [
		C_Player.new(),
		C_Transform.new(self.global_transform),
		C_Health.new(100),
		C_Score.new(0),
		C_Xp.new(0),
		C_Input.new(),
		C_SpellCooldown.new(0.0),
	]

func on_ready():
	add_to_group("player")
	# Sync transform to component on spawn
	if has_component(C_Transform):
		var c_trs := get_component(C_Transform) as C_Transform
		c_trs.transform = self.global_transform

func on_update(_delta: float) -> void:
	# Keep component and node transform in sync after systems update
	if has_component(C_Transform):
		var c_trs := get_component(C_Transform) as C_Transform
		self.global_transform = c_trs.transform
