class_name C_Input
extends Component

# Movement input vector (x = left/right, y = unused, z = forward/back)
@export var move_vector: Vector3 = Vector3.ZERO
# True if jump is pressed this frame
@export var jump: bool = false
# True if spell cast is pressed this frame
@export var cast_spell: bool = false

func clear():
	move_vector = Vector3.ZERO
	jump = false
	cast_spell = false
