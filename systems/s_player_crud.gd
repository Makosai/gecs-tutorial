class_name PlayerCrudSystem
extends System

var phase := 0
var player_entity : Player = null

func query() -> QueryBuilder:
	# This system doesn't need to process any existing entities by query.
	process_empty = true
	return q

func process_all(_entities, _delta):
	match phase:
		0:
			# Create the player entity (visible capsule) and add to ECS.world
			var PlayerScene = preload("res://entities/e_player.tscn")
			player_entity = PlayerScene.instantiate()
			get_tree().current_scene.add_child(player_entity)
			ECS.world.add_entity(player_entity)
			print("Player entity created: ", player_entity)
			phase += 1
		1:
			# Read/log player details
			_log_player_details("Initial Player Details")
			phase += 1
		2:
			# Update player details
			if player_entity and ECS.world.entities.has(player_entity):
				var health := player_entity.get_component(C_Health) as C_Health
				var score := player_entity.get_component(C_Score) as C_Score
				var xp := player_entity.get_component(C_Xp) as C_Xp
				var pos := player_entity.get_component(C_Position) as C_Position
				if health:
					health.current = 50
					health.maximum = 150
				if score:
					score.score = 99
				if xp:
					xp.xp = 42
				if pos:
					pos.position = Vector3(2, 1, -2)
				player_entity.global_position = Vector3(2, 1, -2)
				print("Player entity updated.")
			phase += 1
		3:
			# Read/log updated player details
			_log_player_details("Updated Player Details")
			phase += 1
		4:
			# Delete player entity
			if player_entity and ECS.world.entities.has(player_entity):
				ECS.world.remove_entity(player_entity)
				print("Player entity deleted.")
			phase += 1
		5:
			# Try to read deleted player entity
			var still_exists = player_entity != null # The node has been freed from memory
			print("Deleted player entity still exists! (ERROR)" if still_exists else "Confirmed: Player entity is deleted.")
			# Optionally, remove this system from the world now that demo is done
			ECS.world.remove_system(self)
		_:
			pass

func _log_player_details(label):
	print("--- ", label, " ---")
	if player_entity and ECS.world.entities.has(player_entity):
		var health := player_entity.get_component(C_Health) as C_Health
		var score := player_entity.get_component(C_Score) as C_Score
		var xp := player_entity.get_component(C_Xp) as C_Xp
		var pos := player_entity.get_component(C_Position) as C_Position
		print("Position: ", str(pos.position) if pos else "None")
		print("Health: ", str(health.current) if health else "None", "/", str(health.maximum) if health else "None")
		print("Score: ", str(score.score) if score else "None")
		print("XP: ", str(xp.xp) if xp else "None")
	else:
		print("Player entity is not valid.")
