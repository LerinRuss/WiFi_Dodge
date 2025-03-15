class_name Playfield extends Node

signal menu_button_pressed

enum Mode {FIRST_OUT, LAST_ONE_STANDING, COOP}

@export var game_mode: Mode = -1 # as the default is 0 that means the first from MODS
@export var player_scene: PackedScene
@export var mob_scene: PackedScene
@export var game_border: Vector2
var player_control_scene: PackedScene

var score: int:
	set(value):
		score = value
		$"HUD".update_score(score)
var total_players_amount: int
var _background_music: AudioStreamPlayer

func _init(game_mode: Mode = -1):  # game_mode = -1 by default 'cause the default that's 0  means the first from MODS
	self.game_mode = game_mode

func _ready():
	print('Playfield. Chosen Mode: ' + Mode.find_key(game_mode)
			+ ' from the pool: ' + str(Mode.keys()))
	show_mode(game_mode)
	self._background_music = $"Background Music"
	
func process_game_over(): # -> bool:
	match self.game_mode:
		Mode.FIRST_OUT:
			return check_first_out()
		Mode.LAST_ONE_STANDING:
			return check_last_one_standing()
		Mode.COOP:
			return check_coop()

func check_first_out() -> bool:
	return self.total_players_amount != self.get_players_amount()

func check_last_one_standing() -> bool:
	if self.total_players_amount == 1:
		return self.check_first_out()
	
	return self.get_players_amount() == 1

func check_coop() -> bool:
	return self.get_players_amount() == 0

func arrange_players(players: Array) -> void:
	for player in players:
		$Players.add_child(player, true)
		self._on_player_spawner_spawned(player)
	
	self.total_players_amount = players.size()

func spawn_mob(mob_spawn_location: Node2D) -> void:
	var mob = mob_scene.instantiate()
	mob.speed = randf_range(150.0, 250.0)
	mob.position = mob_spawn_location.position
	mob.vector_step = Vector2.RIGHT.rotated(mob_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4))
	mob.screen_exited.connect(mob.queue_free)

	$Mobs.add_child(mob, true)

func show_temp_message(text: String) -> Signal:
	return $"HUD Message".show_temp_message(text)

func show_message(text: String) -> void:
	$"HUD Message".show_message(text)

func play_music() -> void:
	self._background_music.play()

func stop_music() -> void:
	self._background_music.stop()

func play_sound() -> void:
	$DeathSound.play()

func stop_sound() -> void:
	$DeathSound.stop()

func show_mode(mode: Playfield.Mode) -> void:
	$HUD.set_mode(mode)

func get_players_amount() -> int:
	return $Players.get_children().size()

func get_mobs_amount() -> int:
	return $Mobs.get_children().size()
	
func free_players():
	for player in $Players.get_children():
		player.free()

func free_mobs():
	for mob in $Mobs.get_children():
		mob.free()

func free_player(id: int):
	for player in $Players.get_children():
		if player.id == id:
			self.total_players_amount = self.total_players_amount - 1
			player.free()

func _on_player_spawner_spawned(spawned_node):
	var player = spawned_node

	player.logic = EntityLogic.new(Rect2(Vector2.ZERO, game_border))
	
	if player.id == multiplayer.get_unique_id():
		player.set_controlable(player_control_scene.instantiate())
		player.set_main_animator()

		return

	player.set_subordinate_animator()

func _on_player_spawner_despawned(node):
	pass

func init_player(id: int):
	var player = player_scene.instantiate()
	player.logic = EntityLogic.new(Rect2(Vector2.ZERO, game_border))
	player.id = id
	
	var size: Vector2 = player.get_shape_boundaries().size
	player.position = get_viewport().get_visible_rect().size / 2 \
						+ Vector2(randf_range(-2. * size.x, 2. * size.x), 
									randf_range(-2 * size.y, 2. * size.y))
	player.body_entered.connect(func(body): player.queue_free())
	
	return player

func _on_hud_menu_button_pressed():
	menu_button_pressed.emit()
