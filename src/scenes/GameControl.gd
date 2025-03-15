# Main Control Node where should be only one main Scene at the same time
# Auxiliary Nodes can be added but should be removed after their completion
# This class should be reinitialized during the live cycle
class_name GameControl extends Node

# Here should be fields only shared between all possible sub nodes 
# (e.g. main menu, server, client and so on)

func _ready():
	replace_on_main_menu()

func on_host_with_bot_pressed():
	var server = bind_server(true)

func bind_server(with_bot: bool) -> Node:
	PhysicsServer2D.set_active(true)
	var game: Playfield = _instantiate_game()
	game.game_mode = Playfield.Mode.values()[randi() % Playfield.Mode.size()]
	game.game_border = Utils.get_screen_size(self)
	game.player_control_scene = Utils.Preloaded.PLAYER_CONTROL
	var rpc_wrapper = GameRpcWrapper.new(game)
	var server: Node = Utils.Preloaded.DODGER_SERVER.instantiate()
	server.name = 'ServerNode'
	server.game_wrapper = rpc_wrapper
	server.with_bot = with_bot
	
	server.error_on_host_occured.connect(
		func on_host_server_error(error: Error):
			var menu: MainMenu = self.reset_state_and_replace_with_main_menu()
	
			menu.show_error_temp_message("Server couldn't be set up. Error code is %s." % error))

	self._bind_game_and_replace(game, rpc_wrapper, [server])
	print('GameControl. Host set up.')
	
	return server

func on_host_pressed():
	var server = bind_server(false)

func on_connect_pressed():
	PhysicsServer2D.set_active(false)
	
	var omenu: MainMenu = self.reset_state_and_replace_with_main_menu()
	omenu._show_message("Trying to connect...")
	
	# Server Listener binding
	var server_listener = ServerListener.new()
	var server_listener_port_binding_await = Promise.new()
	server_listener.socket_bound.connect(
		func(error: Error):
			if error != OK:
				server_listener_port_binding_await.reject("Faild to bind to port. \
					Ensure there is no another client. Error Code is %s." % error)
			else:
				server_listener_port_binding_await.resolve())
	
	add_child(server_listener)
	var server_listener_await_res = await server_listener_port_binding_await.async_awaiter()
	
	if server_listener_await_res is Promise.Error:
		var main_menu = reset_state_and_replace_with_main_menu()
		main_menu.show_error_temp_message(server_listener_await_res.get_error())
		
		return
	
	# Server Listener getting server info
	var server_info_catcher = Catcher.new()
	
	server_listener.new_server.connect(
		func(server_info: ServerListener.ServerInfo): server_info_catcher.caught_obj = server_info)
	
	await server_listener.new_server
	
	print('GameControl. Caught Server Info is %s.' % server_info_catcher.caught_obj)
	var server_info: ServerListener.ServerInfo = server_info_catcher.caught_obj
	
	# Multiplayer connecting the server peer
	multiplayer.server_disconnected.connect(
		func (): 
			var menu: MainMenu = self.reset_state_and_replace_with_main_menu()
			menu.show_error_temp_message("The server's been shut down."))
	var connection_await = Promise.new()
	multiplayer.connected_to_server.connect(
		func(): 
			print("GameControl. Connecion client initialization is done.")
			connection_await.resolve())
	multiplayer.connection_failed.connect(func(): connection_await.reject(
			"Connection Failed. The server is full or not started."))
	
	assert(server_info.sender_ip != null)
	
	print('GameControl. Received Data: '  + str(server_info.received_data))
	print('GameControl. Sender IP: ' + str(server_info.sender_ip))
	var server_conn_info: ServerConnectionInfo = ServerConnectionInfo.from_data(server_info.received_data)
	
	var res = Client.instantiate_peer(server_info.sender_ip, server_conn_info.port)
	
	if res is Client.Error:
		var main_menu: MainMenu = reset_state_and_replace_with_main_menu()
		main_menu.show_error_temp_message("Couldn't set up a client. Code is %s" % res.cause)
		
		return
	
	multiplayer.multiplayer_peer = res
	
	var await_res = await connection_await.async_awaiter()
	
	if await_res is Promise.Error:
		var main_menu: MainMenu = reset_state_and_replace_with_main_menu()
		main_menu.show_error_temp_message(await_res.get_error())
		
		return
	
	server_listener.queue_free()
	
	# WiFi Game Instantiating the game
	var game: Playfield = _instantiate_game()
	game.game_mode = server_conn_info.mode
	game.game_border = server_conn_info.screen_size
	
	var original_size: Vector2 = Utils.get_screen_size(self)
	print("GameControl. Server Size. Size %s." % server_conn_info.screen_size)
	print("GameControl. Original Size. Size %s." % original_size)
	var scale: Vector2 = original_size / server_conn_info.screen_size
	get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(scale)
	print("GameControl. New Original Size. Size %s." % Utils.get_screen_size(self))
	
	_bind_game_and_replace(game, GameRpcWrapper.new(game), [])
	
	print('Game Control. Client is ready.')
	print("GameControl. Await for the server is completed.")

func reset_state_and_replace_with_main_menu() -> MainMenu:
	PhysicsServer2D.set_active(true)
	self.multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

	for conn: Dictionary in multiplayer.server_disconnected.get_connections():
		multiplayer.server_disconnected.disconnect(conn["callable"])
		
	for conn: Dictionary in multiplayer.peer_disconnected .get_connections():
		multiplayer.peer_disconnected.disconnect(conn["callable"])
	
	for conn: Dictionary in multiplayer.peer_connected.get_connections():
		multiplayer.peer_connected.disconnect(conn["callable"])
	
	for conn: Dictionary in multiplayer.connection_failed.get_connections():
		multiplayer.connection_failed.disconnect(conn["callable"])
	
	for conn: Dictionary in multiplayer.connected_to_server.get_connections():
		multiplayer.connected_to_server.disconnect(conn["callable"])
		
	get_viewport().canvas_transform = Transform2D.IDENTITY
	
	return replace_on_main_menu()

func _bind_game_and_replace(game: Playfield, game_rpc_wrapper: GameRpcWrapper, nodes: Array[Node]):
	Advertisement.hide_banner()
	var wifi_game: Node = Node.new()
	wifi_game.name = 'WiFiGame'
	
	wifi_game.add_child(game)
	wifi_game.add_child(game_rpc_wrapper)
	for node: Node in nodes:
		wifi_game.add_child(node)
	
	replace(wifi_game)

func replace_on_main_menu() -> MainMenu:
	var main_menu: Node = preload("res://src/scenes/MainMenu.tscn").instantiate()
	main_menu.connect_pressed.connect(self.on_connect_pressed)
	main_menu.host_pressed.connect(self.on_host_pressed)
	main_menu.host_with_bot_pressed.connect(self.on_host_with_bot_pressed)
	
	self.replace(main_menu)
	Advertisement.show_banner()
	
	return main_menu

func replace(new_scene: Node):
	for child in get_children():
		child.queue_free()
	add_child(new_scene)

func _instantiate_game() -> Playfield:
	var game: Playfield = preload("res://src/scenes/Playfield.tscn").instantiate()
	game.menu_button_pressed.connect(self.reset_state_and_replace_with_main_menu)
	game.player_scene = Utils.Preloaded.PLAYER_SCENE
	game.mob_scene = Utils.Preloaded.MOB_SCENE
	
	return game

class Catcher extends RefCounted:
	var caught_obj
