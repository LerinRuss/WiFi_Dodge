class_name Client extends RefCounted

static func instantiate_peer(server_ip: String, server_port: int): # -> ENetMultiplayerPeer:
	var peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(server_ip, server_port)
	
	if error != OK:
		return error
	
	return peer

class Error:
	var cause: Error
	
	func _init(cause: Error):
		self.cause = cause
