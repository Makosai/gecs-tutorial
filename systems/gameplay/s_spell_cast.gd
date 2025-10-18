class_name SpellCastSystem
extends System

const SpellScene := preload("res://entities/e_spell.tscn")

@export var spell_speed: float = 25.0
@export var spell_cooldown_time: float = 0.5
@export var cast_sfx: AudioStream

var _default_cast_stream: AudioStreamWAV

func _init():
	self.name = "SpellCastSystem"
	self.group = "gameplay"
	_default_cast_stream = _make_default_cast_stream()

func query() -> QueryBuilder:
	return q.with_all([C_Camera, C_Input, C_SpellCooldown, C_Transform])

func process(entity: Entity, delta: float) -> void:
	var c_input := entity.get_component(C_Input) as C_Input
	var c_cd := entity.get_component(C_SpellCooldown) as C_SpellCooldown
	var c_transform := entity.get_component(C_Transform) as C_Transform
	if not c_input or not c_cd or not c_transform:
		return

	# Tick cooldown timer
	if c_cd.cooldown > 0.0:
		c_cd.cooldown = max(c_cd.cooldown - delta, 0.0)

	if not c_input.cast_spell:
		return

	if c_cd.cooldown > 0.0:
		return

	var player_transform := c_transform.transform
	var forward := -player_transform.basis.z
	if forward.is_zero_approx():
		forward = Vector3.FORWARD

	var spell := SpellScene.instantiate() as Spell
	if not spell:
		push_warning("Failed to instantiate spell scene")
		return
	spell.name = "Spell_%s" % Time.get_ticks_msec()
	spell.global_transform = player_transform

	ECS.world.add_entity(spell)
	spell.configure(forward, spell_speed)

	c_cd.cooldown = spell_cooldown_time
	_print_spell_cast(entity)
	_play_cast_sound(player_transform.origin)

func _print_spell_cast(entity: Entity) -> void:
	print("Spell cast by %s" % entity.name)

func _play_cast_sound(position: Vector3) -> void:
	var stream: AudioStream = cast_sfx if cast_sfx != null else _default_cast_stream
	if stream == null:
		return
	var sfx_player := AudioStreamPlayer3D.new()
	sfx_player.stream = stream
	sfx_player.global_position = position
	var tree := get_tree()
	if tree == null:
		return
	var parent := tree.current_scene if tree.current_scene else tree.root
	parent.add_child(sfx_player)
	sfx_player.finished.connect(func():
		sfx_player.queue_free()
	)
	sfx_player.play()

func _make_default_cast_stream() -> AudioStreamWAV:
	var sample := AudioStreamWAV.new()
	sample.format = AudioStreamWAV.FORMAT_16_BITS
	sample.mix_rate = 22050
	sample.stereo = false
	sample.loop_mode = AudioStreamWAV.LOOP_DISABLED

	var duration := 0.18 # slightly longer for a fireball
	var base_freq := 20.0 # lower base frequency for bass
	var freq_sweep := 180.0 # sweep up for a bit of movement
	var sample_count := int(sample.mix_rate * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for i in sample_count:
		var t := float(i) / sample.mix_rate
		var envelope := pow(1.0 - float(i) / sample_count, 2.0) # slower fade for more punch
		var freq := base_freq + freq_sweep * (float(i) / sample_count)
		var value := int((sin(PI * 2.0 * freq * t) + 0.3 * sin(PI * 2.0 * freq * t * 0.5)) * 0.5 * envelope * 32767.0)
		var index := i * 2
		data[index] = value & 0xFF
		data[index + 1] = (value >> 8) & 0xFF
	sample.data = data
	return sample
