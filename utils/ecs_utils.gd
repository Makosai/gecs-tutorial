class_name ECSUtils

static func sync_transform(entity):
	if entity.has_component(C_Position):
		var c_pos = entity.get_component(C_Position)
		c_pos.position = entity.global_position

static func sync_from_component(entity):
	if entity.has_component(C_Position):
		var c_pos = entity.get_component(C_Position)
		entity.global_position = c_pos.position
