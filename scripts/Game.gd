class_name Game extends RefCounted

enum Mode {FIRST_OUT, LAST_ONE_STANDING, COOP}
static var MODS: Dictionary = {
	Mode.FIRST_OUT: func (game: Game, players: int) -> bool: return game.total_players_amount != players,
	Mode.LAST_ONE_STANDING: func (playfield: Playfield) -> bool: return playfield.check_last_one_standing(),
	Mode.COOP: func (playfield: Playfield) -> bool: return playfield.check_coop()
}

const _player_scene: PackedScene = preload("res://scenes/WiFiPlayer.tscn")
const _mob_scene: PackedScene = preload("res://scenes/WiFiMob.tscn")
var score: int
var GAME_MODE: Game.Mode: # as by default is 0 that means the first from MODS
	get:
		return GAME_MODE
var _PLAYGROUND_SIZE: Vector2:
	get:
		return _PLAYGROUND_SIZE
var _total_players_amount: int


func __init__(game_mode: Game.Mode, playground_size: Vector2):
	self.GAME_MODE = game_mode
	self.PLAYGROUND_SIZE = playground_size

func init_players(ids: PackedInt32Array) -> Array[Player]:
	var res = []
	for id in ids:
		var player: Player = self._init_player(id)
		player.body_entered.connect(func(body): player.queue_free())
		res.append(player)
	
	self._total_players_amount = res.size()
	
	return res

func _check_first_out(players: int) -> bool:
	return self.total_players_amount != players

func _check_last_one_standing(players: int) -> bool:
	if self.total_players_amount == 1:
		return self._check_first_out(players)
	
	return players == 1

func _check_coop(players: int) -> bool:
	return players == 0

func _init_player(id: int) -> Player:
	var player = _player_scene.instantiate()
	player.id = id
	
	var size: Vector2 = player.get_shape_boundaries().size
	player.position = self._PLAYGROUND_SIZE / 2 + Vector2(randf_range(-2. * size.x, 2. * size.x), 
													randf_range(-2 * size.y, 2. * size.y))
	return player

func _init_mob(mob_spawn_location: Node2D) -> Node:
	var mob = _mob_scene.instantiate()
	mob.speed = randf_range(150.0, 250.0)
	mob.position = mob_spawn_location.position
	mob.vector_step = Vector2.RIGHT.rotated(mob_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4))
	mob.screen_exited.connect(mob.queue_free)
	
	return mob
