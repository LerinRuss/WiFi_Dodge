extends RigidBody2D

signal screen_exited

@export var speed: float
@export var rad_angle: float = 0
@export var vector_step: Vector2: 
	set(step):
		linear_velocity = step.normalized() * speed
		rotation = step.angle() + rad_angle
	get:
		return linear_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $Animation.sprite_frames.get_animation_names()
	$Animation.animation = mob_types[randi() % mob_types.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity.length() > 0:
		$Animation.play()
	else:
		$Animation.stop()


func _on_visible_on_screen_notifier_2d_screen_exited():
	screen_exited.emit()
