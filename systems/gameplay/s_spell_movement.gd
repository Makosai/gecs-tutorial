class_name SpellMovementSystem
extends System

const ROOM_LIMIT := 25.0

func _init() -> void:
	self.name = "SpellMovementSystem"
	self.group = "gameplay"

func query() -> QueryBuilder:
	return q.with_all([C_Spell, C_Transform, C_Velocity, C_Lifetime])

func process(entity: Entity, delta: float) -> void:
	var c_transform := entity.get_component(C_Transform) as C_Transform
	var c_velocity := entity.get_component(C_Velocity) as C_Velocity
	var c_lifetime := entity.get_component(C_Lifetime) as C_Lifetime
	if not c_transform or not c_velocity or not c_lifetime:
		return

	var spell_area := entity as Node as Area3D
	var velocity: Vector3 = c_velocity.velocity
	var origin: Vector3 = c_transform.transform.origin
	var new_origin: Vector3 = origin + velocity * delta
	var basis: Basis = c_transform.transform.basis
	if velocity.length_squared() > 0.0001:
		basis = Basis.looking_at(velocity.normalized(), Vector3.UP)

	var new_transform := Transform3D(basis, new_origin)
	c_transform.transform = new_transform
	entity.global_transform = new_transform

	if _handle_collisions(spell_area, entity):
		return

	if _is_out_of_bounds(new_origin):
		_destroy_spell(entity, "out of bounds")
		return

	c_lifetime.tick(delta)
	if c_lifetime.expired():
		_destroy_spell(entity, "expired")

func _handle_collisions(spell_area: Area3D, entity: Entity) -> bool:
	if spell_area == null:
		return false

	for col in spell_area.get_overlapping_bodies():
		if col == null or col == entity:
			continue
		if col.is_in_group("player") or col.is_in_group("spell"):
			continue
		_log_collision(col)
		_destroy_spell(entity, "")
		return true

	return false

func _log_collision(target: Node) -> void:
	var descriptor := target.name
	if target.is_in_group("enemy"):
		descriptor = "enemy '%s'" % target.name
	elif target.is_in_group("crate"):
		descriptor = "crate '%s'" % target.name
	elif target.name.begins_with("Wall"):
		descriptor = "wall '%s'" % target.name
	print("Spell hit %s" % descriptor)

func _is_out_of_bounds(position: Vector3) -> bool:
	return absf(position.x) > ROOM_LIMIT or absf(position.z) > ROOM_LIMIT or position.y < -5.0 or position.y > ROOM_LIMIT

func _destroy_spell(entity: Entity, reason: String) -> void:
	if reason != "":
		print("Spell destroyed (%s)." % reason)
	if ECS.world and ECS.world.entities.has(entity):
		ECS.world.remove_entity(entity)
	elif entity.is_inside_tree():
		entity.queue_free()
