@tool
class_name Spell
extends Entity

const DEFAULT_SPEED := 25.0
const DEFAULT_LIFETIME := 3.0

func define_components() -> Array:
	return [
		C_Spell.new(),
		C_Transform.new(self.global_transform),
		C_Velocity.new(Vector3.ZERO),
		C_Lifetime.new(DEFAULT_LIFETIME),
	]

func on_ready() -> void:
	add_to_group("spell")

	if has_component(C_Transform):
		var c_trs := get_component(C_Transform)
		c_trs.transform = self.global_transform

	if has_component(C_Lifetime):
		var c_lifetime := get_component(C_Lifetime)
		if c_lifetime.time_left <= 0.0:
			c_lifetime.reset(DEFAULT_LIFETIME)

func on_update(_delta: float) -> void:
	if has_component(C_Transform):
		var c_trs := get_component(C_Transform)
		self.global_transform = c_trs.transform

func configure(direction: Vector3, speed: float = DEFAULT_SPEED) -> void:
	var c_velocity := get_component(C_Velocity)
	if c_velocity:
		var dir := direction.normalized()
		if dir == Vector3.ZERO:
			dir = Vector3.FORWARD
		c_velocity.velocity = dir * speed
