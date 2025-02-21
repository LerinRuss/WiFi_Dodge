class_name Player extends Area2D

@export var speed = 250 # How fast the player will move (pixels/sec).
@export var step_vector: Vector2 = Vector2.ZERO : 
	set(step):
		step_vector = step.normalized()
var logic: EntityLogic

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.play()

func _process(delta):
	if step_vector.length() > 0:
		position += step_vector * speed * delta
		position = logic.process_position(position)
		rotation = step_vector.angle() + PI/2

func set_main_animator():
	$Animation.animation = 'main'

func set_subordinate_animator():
	$Animation.animation = 'subordinate'

func get_shape_boundaries() -> Rect2:
	return $CollisionShape2D.shape.get_rect()

# TBD remove?
func disable():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	show()
	$CollisionShape2D.disabled = false
