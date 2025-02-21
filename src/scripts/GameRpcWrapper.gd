class_name GameRpcWrapper extends Node

@export var game: Playfield

func _init(game:Playfield = null):
	self.game = game
	
	self.name = 'GameRpcWrapper'

func show_temp_message_and_locally(text: String) -> Signal:
	self.show_temp_message.rpc(text)
	
	return self.show_temp_message(text)

@rpc("authority", "call_local", "reliable")
func show_message(text: String) -> void:
	self.game.show_message(text)

@rpc("authority", "call_remote", "reliable")
func show_temp_message(text: String) -> Signal:
	return self.game.show_temp_message(text)

@rpc("authority", "call_local", "reliable")
func play_music() -> void:
	self.game.play_music()
	
@rpc("authority", "call_local", "reliable")
func stop_music() -> void:
	self.game.stop_music()
	
@rpc("authority", "call_local", "reliable")
func play_sound() -> void:
	self.game.play_sound()
	
@rpc("authority", "call_local", "reliable")
func stop_sound() -> void:
	self.game.stop_sound()
	
@rpc("authority", "call_local", "reliable")
func set_score(score: int) -> void:
	self.game.score = score
