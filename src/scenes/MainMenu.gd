class_name MainMenu extends CanvasLayer

signal host_pressed
signal host_with_bot_pressed
signal connect_pressed

@onready var _info_label: Label = $VBoxContainer/InfoLabel
var _background_music: AudioStreamPlayer

func _ready():
	self._background_music = $"Baclground Music"
	play_background_music()

func _on_host_pressed():
	self.host_pressed.emit()

func _on_host_with_bot_pressed():
	self.host_with_bot_pressed.emit()

func _on_connect_pressed():
	self.connect_pressed.emit()
	
func _on_host_settings_pressed():
	var window = Utils.Preloaded.HOST_SETTINGS.instantiate()
	
	add_child(window)

func _show_message(text: String) -> void:
	self._info_label.add_theme_color_override('font_color', Color(1, 1, 1))
	self._info_label.show_message(text)

func show_error_temp_message(text: String):
	ToastParty.show({
		"text": text,
		"direction": 'center',
		"gravity": 'top',
		"bgcolor": Color(1, 0, 0, 0.7),
		"color": Color(1, 1, 1, 1)
	})

func hide_message():
	self._info_label.hide()

func play_background_music():
	self._background_music.play()
