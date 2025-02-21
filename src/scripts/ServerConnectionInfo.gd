class_name ServerConnectionInfo extends RefCounted

var port: int
var mode: Playfield.Mode
var screen_size: Vector2

func _init(port: int, mode: Playfield.Mode, screen_size: Vector2):
	self.port = port
	self.mode = mode
	self.screen_size = screen_size

# Dictionary[String, Object]
func to_dictionary() -> Dictionary:
	return {
		"port": port,
		"mode": mode,
		"screen_size_x": screen_size.x,
		"screen_size_y": screen_size.y
	}

static func from_data(data: Variant) -> ServerConnectionInfo:
	return ServerConnectionInfo.new(data["port"], data["mode"], 
		Vector2(data["screen_size_x"], data["screen_size_y"]))
