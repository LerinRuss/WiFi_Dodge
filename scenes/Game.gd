class_name Game extends Node

enum Mode {FIRST_OUT, LAST_ONE_STANDING, COOP}

static var MODS: Dictionary = {
	Mode.FIRST_OUT: func (game: Game) -> bool: return game.check_first_out(),
	Mode.LAST_ONE_STANDING: func (game: Game) -> bool: return game.check_last_one_standing(),
	Mode.COOP: func (game: Game) -> bool: return game.check_coop()
}

@export var game_mode: Game.Mode = -1 # as ny default is 0 that means the first from MODS

const _player_scene = preload("res://scenes/WiFiPlayer.tscn")
const _mob_scene: PackedScene = preload("res://scenes/WiFiMob.tscn")

var score: int
var total_players_amount: int

func _ready():
	print('Game. Chosen Mode: ' + Mode.find_key(game_mode)
			+ ' from the pool: ' + str(Mode.keys()))
	_show_mode(game_mode)

func check_first_out() -> bool:
	return self.total_players_amount != self.get_players().size()

func check_last_one_standing() -> bool:
	if self.total_players_amount == 1:
		return self.check_first_out()
	
	return self.get_players().size() == 1

func check_coop() -> bool:
	return self.get_players().size() == 0

func arrange_players(ids: PackedInt32Array) -> void:
	for id in ids:
		var player = self._init_player(id)
		$Players.add_child(player, true)
		self._on_player_spawner_spawned(player)
	
	self.total_players_amount = ids.size()

func spawn_mob(mob_spawn_location: Node2D) -> void:
	var mob: Node = self._init_mob(mob_spawn_location)
	$Mobs.add_child(mob, true)

func show_temp_message(text: String) -> Signal:
	RpcAwait.send_rpc_all($"HUD Temporary".show_temp_message.bind(text))
	
	return $"HUD Temporary".show_temp_message(text)

func show_message(text: String) -> void:
	show_message_remotely.rpc(text)

@rpc("authority", "call_local", "reliable")
func show_message_remotely(text: String) -> void:
	$"HUD Temporary".show_message(text)

func play_music() -> void:
	self.play_music_remotely.rpc()

@rpc("authority", "call_local", "reliable")
func play_music_remotely() -> void:
	$Music.play()

func stop_music() -> void:
	self.stop_music_remotely.rpc()

@rpc("authority", "call_local", "reliable")
func stop_music_remotely() -> void:
	$Music.stop()

func play_sound() -> void:
	self.play_sound_remotely.rpc()

@rpc("authority", "call_local", "reliable")
func play_sound_remotely() -> void:
	$DeathSound.play()

func stop_sound() -> void:
	self.stop_sound_remotely.rpc()

@rpc("authority", "call_local", "reliable")
func stop_sound_remotely() -> void:
	$DeathSound.stop()

func set_score(score: int) -> void:
	set_score_remotely.rpc(score)

@rpc("authority", "call_local", "reliable")
func set_score_remotely(score: int) -> void:
	self.score = score
	$"HUD".update_score(score)

@rpc("authority", "call_remote", "reliable")
func show_mode_remotely(mode: Game.Mode) -> void:
	$HUD.set_mode(mode)

func _show_mode(mode: Game.Mode) -> void:
	$HUD.set_mode(mode)

func get_score() -> int:
	return self.score

func get_players() -> Array[Node]:
	return $Players.get_children()

func get_mobs() -> Array[Node]:
	return $Mobs.get_children()

func _on_player_spawner_spawned(spawned_node):
	var player = spawned_node
	
	if player.id != multiplayer.get_unique_id():
		player.set_dark_grey_animator()
		
		return
	
	player.set_controlable()
	player.set_grey_animator()
	player.set_camera()

func _on_player_spawner_despawned(node):
	pass

func _init_player(id: int):
	var player = _player_scene.instantiate()
	player.id = id
	
	var size: Vector2 = player.get_shape_boundaries().size
	player.position = get_viewport().get_visible_rect().size / 2 \
						+ Vector2(randf_range(-2. * size.x, 2. * size.x), 
									randf_range(-2 * size.y, 2. * size.y))
	player.body_entered.connect(func(body): player.queue_free())
	
	return player

func _init_mob(mob_spawn_location: Node2D) -> Node:
	var mob = _mob_scene.instantiate()
	mob.speed = randf_range(150.0, 250.0)
	mob.position = mob_spawn_location.position
	mob.vector_step = Vector2.RIGHT.rotated(mob_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4))
	mob.screen_exited.connect(mob.queue_free)
	
	return mob
