class_name MainMenu extends CanvasLayer

signal host_pressed
signal connect_pressed

var _info_label: Label

func _ready():
	self._info_label = $CenterContainer/Menu/InfoLabel
	for ip in IP.get_local_addresses():
		if ip.begins_with('192.168'):
			self._info_label.text = ip
			
			break

func _on_host_pressed():
	self.host_pressed.emit()

func _on_connect_pressed():
	self.connect_pressed.emit()

func show_message(text: String) -> void:
	self._info_label.add_theme_color_override('font_color', Color(1, 1, 1))
	self._info_label.show_message(text)

func show_temp_message(text: String) -> Signal:
	self._info_label.add_theme_color_override('font_color', Color(1, 1, 1))
	return self._info_label.show_temp_message(text)

func show_error_message(text: String) -> void:
	self._info_label.add_theme_color_override('font_color', Color(1, 0, 0))
	self._info_label.show_message(text)

func show_error_temp_message(text: String) -> Signal:
	self._info_label.add_theme_color_override('font_color', Color(1, 0, 0))
	return self._info_label.show_temp_message(text)

func hide_message():
	self._info_label.hide()
