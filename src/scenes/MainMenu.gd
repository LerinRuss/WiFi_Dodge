class_name MainMenu extends CanvasLayer

signal host_pressed
signal connect_pressed

@onready var _info_label: Label = $VBoxContainer/InfoLabel

func _ready():
	var admob_banner_id: String
	
	if OS.has_feature("release"):
		admob_banner_id = ProjectSettings.get("admob/banner_real_id")
	else:
		admob_banner_id = ProjectSettings.get("admob/banner_test_id")
	
	var ad_view := AdView.new(admob_banner_id, AdSize.BANNER, AdPosition.Values.BOTTOM)
	ad_view.load_ad(AdRequest.new())
	ad_view.show()

func _on_host_pressed():
	self.host_pressed.emit()
	
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
