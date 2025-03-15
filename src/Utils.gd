class_name Utils extends RefCounted

# returns String
static func find_wifi_ip():
	for ip in IP.get_local_addresses():
		if not ip.is_valid_ip_address() or ip.begins_with('127.') \
				or ip.begins_with("169.254"):
			continue
		
		if ip.split(".").size() != 4:
			continue
		return ip
	return null

static func get_screen_size(self_node: Node) -> Vector2:
	return self_node.get_viewport().get_visible_rect().size

static func produce_node_with_script(script: Script) -> Node:
	var node = Node.new()
	node.set_script(script)
	
	return node

class Preloaded:
	static var DODGER_SERVER: PackedScene = preload("res://src/scenes/DodgerServer.tscn")
	static var PLAYER_SCENE: PackedScene = preload("res://src/scenes/WiFiPlayer.tscn")
	static var MOB_SCENE: PackedScene = preload("res://src/scenes/WiFiMob.tscn")
	static var HOST_SETTINGS: PackedScene = preload("res://src/scenes/HostSettings.tscn")
	static var PLAYER_CONTROL: PackedScene = preload("res://src/scenes/control/FullPlayerControl.tscn")
