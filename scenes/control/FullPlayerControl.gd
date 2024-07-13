class_name FullPlayerControl extends Node

@export var player: Player:
	set(_player):
		player = _player
		$KeyBoardPlayerControl.player = _player
		$FullScreen_Player_VJ_Control.player = _player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
