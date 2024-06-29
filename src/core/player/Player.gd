#class_name Player 
extends Area2D

signal hit

@export var speed = 250 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var step_vector: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if step_vector.length() > 0:
		position += step_vector * speed * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		rotation = step_vector.angle() + PI/2
		
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func set_step_vector(step_vector: Vector2):
	self.step_vector = step_vector


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
