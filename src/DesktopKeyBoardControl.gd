extends Node

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var step_vector = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		step_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		step_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		step_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		step_vector.y -= 1
	
	player.set_step_vector(step_vector.normalized())