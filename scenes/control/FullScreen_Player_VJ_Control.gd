class_name FullScreen_Player_VJ_Control extends CanvasLayer

@export var player: Player
var _joystick: VirtualJoystick

# Called when the node enters the scene tree for the first time.
func _ready():
	self._joystick = $"Virtual Joystick"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _joystick.is_pressed:
		player.step_vector = _joystick.output
