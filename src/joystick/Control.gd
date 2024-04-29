extends Node

@export var player: Player
@export var joystick: VirtualJoystick

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if joystick.is_pressed:
		player.set_step_vector(joystick.output)
