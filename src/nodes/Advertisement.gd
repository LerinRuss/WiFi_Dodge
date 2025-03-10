extends Node

var ad_wrapper: AdWrapper

func _init():
	var ad_enabled: bool = ProjectSettings.get("admob/ad_enabled")
	if ad_enabled:
		self.ad_wrapper = AdMobWrapper.new(ProjectSettings.get("admob/banner_id"))
	else:
		self.ad_wrapper = AdEmptyWrapper.new()

func show_banner():
	self.ad_wrapper.show_banner()

func hide_banner():
	self.ad_wrapper.hide_banner()

class AdWrapper:
	func show_banner():
		pass
	
	func hide_banner():
		pass

class AdEmptyWrapper extends AdWrapper:
	func show_banner():
		pass
	
	func hide_banner():
		pass

class AdMobWrapper extends AdWrapper:
	var _banner: AdView
	
	func _init(admob_banner_id: String):
		MobileAds.initialize()
		self._banner = AdView.new(admob_banner_id, AdSize.BANNER, AdPosition.Values.BOTTOM)
		self._banner.load_ad(AdRequest.new())

	func show_banner():
		self._banner.show()

	func hide_banner():
		self._banner.hide()
