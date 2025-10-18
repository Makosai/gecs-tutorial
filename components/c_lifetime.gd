class_name C_Lifetime
extends Component

@export var duration: float = 3.0
@export var time_left: float = 3.0

func _init(ttl: float = 3.0):
	duration = max(ttl, 0.0)
	time_left = duration

func reset(ttl: float = -1.0) -> void:
	if ttl > 0.0:
		duration = ttl
	time_left = duration

func tick(delta: float) -> void:
	time_left = max(time_left - delta, 0.0)

func expired() -> bool:
	return time_left <= 0.0
