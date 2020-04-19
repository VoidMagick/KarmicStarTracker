extends VBoxContainer

signal time_reset()

func _ready():
	
	connect("time_reset",get_node("TimeGrid/EYear"),"control_reset")
	connect("time_reset",get_node("TimeGrid/EMonth"),"control_reset")
	connect("time_reset",get_node("TimeGrid/EDay"),"control_reset")
	connect("time_reset",get_node("TimeGrid/EHour"),"control_reset")
	connect("time_reset",get_node("TimeGrid/EMinute"),"control_reset")

func _on_ResetTime_pressed():
	emit_signal("time_reset")
