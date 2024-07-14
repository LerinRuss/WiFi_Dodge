class_name GameControl extends Node

static var PORT = 7000

func on_host_pressed():
	var game: Playfield = _instantiate_game()
	game.game_mode = Playfield.Mode.values()[randi() % Playfield.Mode.size()]
	
	var rpc_wrapper = GameRpcWrapper.new(game)
	
	var server: Node = preload("res://scenes/DodgerServer.tscn").instantiate()
	server.name = 'ServerNode'
	server.game_wrapper = rpc_wrapper

	self._pack_together_and_change(game, [server, rpc_wrapper])
	print('GameControl. Host set up.')

func on_connect_pressed():
	PhysicsServer2D.set_active(false)
	var server_listener: ServerListener = ServerListener.new()
	
	add_child(server_listener)
	server_listener.new_server.connect(self.server_found.bind(server_listener))
	
	await server_listener.new_server
	print("GameControl. Await for the server is completed.")

func server_found(server_info, server_listener: ServerListener):
	assert(server_info.sender_ip != null)
	assert(server_info.received_data != null 
		and server_info.received_data.has("port")
		and server_info.received_data.size() == 1)
	
	print('DodgerClient. Received Data: '  + str(server_info.received_data))
	print('DodgerClient. Sender IP: ' + str(server_info.sender_ip))
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(server_info.sender_ip, server_info.received_data["port"])
	
	assert(!error)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(self.server_connected.bind(server_listener))
	await multiplayer.connected_to_server
	print("GameControl. Connecion client initialization is done.")

func server_connected(server_listener: ServerListener):
	server_listener.queue_free()
	
	var game: Playfield = _instantiate_game()
	game.game_mode = Playfield.Mode.FIRST_OUT
	
	_pack_together_and_change(game, [GameRpcWrapper.new(game)])
	
	print('Game Control. Client is ready.')

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
