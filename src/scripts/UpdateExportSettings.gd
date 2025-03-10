@tool
extends EditorScript

func _run():
	_log("Started.")
	var env_banner_id_name = "ADMOB_BANNER_ID"
	var env_ad_enabled_name = "AD_ENABLED"
	var ad_enabled = false
	
	if (OS.has_environment(env_ad_enabled_name) 
			and OS.get_environment(env_ad_enabled_name).to_lower() == "true"
			and OS.has_environment(env_banner_id_name)):
		var banner_id = OS.get_environment(env_banner_id_name)
		_log("Env Var {0}: {1}.".format([env_banner_id_name, banner_id]))
		
		if not banner_id.strip_edges().is_empty():
			ad_enabled = true
			_log("Env Var {0} is set.".format([env_banner_id_name]))
			ProjectSettings.set("admob/banner_id", banner_id)
	
	ProjectSettings.set("admob/ad_enabled", ad_enabled)
	_log("ad enabled setting is set to {0}".format([ad_enabled]))

	ProjectSettings.save()
	_log("Export settings updated!")

func _log(log_msg: String):
	print("UpdateExportSettings. " + log_msg)
