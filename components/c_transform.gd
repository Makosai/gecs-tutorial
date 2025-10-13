class_name C_Transform
extends Component

@export var transform: Transform3D = Transform3D.IDENTITY

func _init(_transform: Transform3D = Transform3D.IDENTITY):
	transform = _transform
