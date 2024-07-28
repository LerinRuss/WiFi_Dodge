@icon("server_advertiser.png")
class_name ServerAdvertiser extends Node

# As ascii is convetion for transfering data in this game 
# then all data should be encapsulated here 

@export var broadcast_port: int = 3111
@export var broadcast_interval: float = 1.0
 
var server_info: Dictionary = {"name": "LAN Game"}
var _socket_udp = PacketPeerUDP.new()

func _init():
	var broadcastTimer = Timer.new()
	broadcastTimer.wait_time = broadcast_interval
	broadcastTimer.one_shot = false
	broadcastTimer.autostart = true
	broadcastTimer.timeout.connect(broadcast)
	add_child(broadcastTimer)
	
	_socket_udp.set_broadcast_enabled(true)
	_socket_udp.set_dest_address('255.255.255.255', broadcast_port)
	

func broadcast():
	_socket_udp.put_packet(JSON.stringify(server_info).to_ascii_buffer()) 


func _exit_tree():
	_socket_udp.close()
