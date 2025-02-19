class_name EntityLogic extends RefCounted

var border: Rect2

func _init(border: Rect2):
	self.border = border

func process_position(position: Vector2):
	return position.clamp(border.position, border.size)
