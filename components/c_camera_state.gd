class_name C_CameraState
extends Component

@export var yaw: float = 0.0 # Horizontal angle (degrees)
@export var pitch: float = -20.0 # Vertical angle (degrees, negative looks down)
@export var pitch_min: float = -80.0
@export var pitch_max: float = 15.0

@export var distance: float = 7.5 # Third-person distance from target
@export var min_distance: float = 2.5
@export var max_distance: float = 7.5

func _init(
	_yaw: float = 0.0,
	_pitch: float = -30.0,
	_pitch_min: float = -80.0,
	_pitch_max: float = 15.0,
	_distance: float = 7.5,
	_min_distance: float = 2.5,
	_max_distance: float = 7.5
):
	yaw = _yaw
	pitch = _pitch
	pitch_min = _pitch_min
	pitch_max = _pitch_max
	distance = _distance
	min_distance = _min_distance
	max_distance = _max_distance
