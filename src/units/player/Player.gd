class_name Player extends Area2D

@export var speed = 250 # How fast the player will move (pixels/sec).
@export var step_vector: Vector2 = Vector2.ZERO : 
	set(step):
		step_vector = step.normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.play()

func _process(delta):
	if step_vector.length() > 0:
		position += step_vector * speed * delta
		position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
		rotation = step_vector.angle() + PI/2

func set_grey_animator():
	$Animation.animation = 'light'

func set_dark_grey_animator():
	$Animation.animation = 'dark'

func get_shape_boundaries() -> Rect2:
	return $CollisionShape2D.shape.get_rect()

# TBD remove?
func disable():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	show()
	$CollisionShape2D.disabled = false
