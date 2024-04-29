@icon("server_listener.png")
class_name ServerListener extends Node

signal new_server(server: ServerInfo)
signal server_decayed(server: ServerInfo)

@export var listen_interval: int = 1
@export var decay_duration: int = 3
@export var listen_port: int = 3111

var _socket_udp = PacketPeerUDP.new()
var _known_servers: Dictionary = {}: # [String, ServerInfo]
	get:
		return _known_servers

func _init():
	var cleaner_timer = Timer.new()
	cleaner_timer.one_shot = false
	cleaner_timer.autostart = true
	cleaner_timer.timeout.connect(_clean_up)
	add_child(cleaner_timer)

func _ready():
	_known_servers.clear()
	assert(_socket_udp.bind(listen_port) == OK)

func _process(delta):
	if _socket_udp.get_available_packet_count() > 0:
		var server_ip: String = _socket_udp.get_packet_ip()
		var server_port: int = _socket_udp.get_packet_port()
		var packet: PackedByteArray = _socket_udp.get_packet()
		
		if server_ip.is_empty():
			return
		
		if not _known_servers.has(server_ip):
			var data = JSON.parse_string(packet.get_string_from_ascii())
			assert(data != null)
			
			var server_info = ServerInfo.new(
				data, server_ip, server_port, Time.get_unix_time_from_system())
			_known_servers[server_ip] = server_info
			new_server.emit(server_info)
		else:
			_known_servers[server_ip].last_seen = Time.get_unix_time_from_system()
		
	
func _exit_tree():
	_socket_udp.close()

func _clean_up():
	var now: float = Time.get_unix_time_from_system()
	
	for server_ip in _known_servers:
		var server_info: ServerInfo = _known_servers[server_ip]
		
		if (now - server_info.last_seen) > decay_duration:
			_known_servers.erase(server_ip)
			server_decayed.emit(server_info)


class ServerInfo:
	var received_data: Variant
	var sender_ip: String
	var sender_port: int
	var last_seen: float
	
	func _init(received_data: Variant, sender_ip: String, sender_port: int, last_seen: float):
		self.received_data = received_data
		self.sender_ip = sender_ip
		self.sender_port = sender_port
		self.last_seen = last_seen
