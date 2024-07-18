class_name GameControl extends Node

const _PORT = 7000

func on_host_pressed():
	var game: Playfield = _instantiate_game()
	game.game_mode = Playfield.Mode.values()[randi() % Playfield.Mode.size()]
	
	var rpc_wrapper = GameRpcWrapper.new(game)
	
	var server: Node = preload("res://scenes/DodgerServer.tscn").instantiate()
	server.name = 'ServerNode'
	server.game_wrapper = rpc_wrapper
	server.port = _PORT
	server.server_info = {"port": _PORT, "mode": game.game_mode}

	self._pack_together_and_change(game, [server, rpc_wrapper])
	print('GameControl. Host set up.')

func on_connect_pressed():
	PhysicsServer2D.set_active(false)
	var server_listener: ServerListener = ServerListener.new()
	
	add_child(server_listener)
	var server_info_catcher = Catcher.new()
	
	server_listener.new_server.connect(func(server_info): server_info_catcher.caught_obj = server_info)
	
	await server_listener.new_server
	
	print('GameControl. Caught Server Info is %s.' % server_info_catcher.caught_obj)
	var server_info = server_info_catcher.caught_obj
	multiplayer.multiplayer_peer = _instantiate_peer(server_info)
	
	multiplayer.connected_to_server.connect(func(): print("GameControl. Connecion client initialization is done."))
	
	await multiplayer.connected_to_server
	
	server_listener.queue_free()
	
	var game: Playfield = _instantiate_game()
	game.game_mode = server_info.received_data["mode"]
	
	_pack_together_and_change(game, [GameRpcWrapper.new(game)])
	
	print('Game Control. Client is ready.')
	print("GameControl. Await for the server is completed.")

func _instantiate_peer(server_info):
	assert(server_info.sender_ip != null)
	assert(server_info.received_data != null 
			and server_info.received_data.has("port"),
		'Server Received Data: %s.' % server_info.received_data)
	
	print('DodgerClient. Received Data: '  + str(server_info.received_data))
	print('DodgerClient. Sender IP: ' + str(server_info.sender_ip))
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(server_info.sender_ip, server_info.received_data["port"])
	
	assert(!error)
	return peer

func _pack_together_and_change(game: Playfield, nodes: Array[Node]):
	var scene = PackedScene.new()

	for node: Node in nodes:
		game.add_child(node)
		node.owner = game
	
	assert(scene.pack(game) == OK)
	ResourceSaver.save(scene, "res://my_packed_scene.tscn")
	assert(get_tree().change_scene_to_packed(scene) == OK)
	
func _instantiate_game() -> Playfield:
	return preload("res://scenes/Playfield.tscn").instantiate()


class Catcher extends RefCounted:
	var caught_obj
