class_name HostSettings extends Window

@onready var _ip_info: Label = $IpContainer/IpInfo

func _ready():
	self._ip_info.text = Utils.find_wifi_ip()

func close() -> void:
	self.queue_free()
