extends Control

signal centric_change(heliocentric)
signal time_change()

func _ready():
	pass

################################################################################
## Changing centric signals

func _on_ChooseCentric_item_selected(id):
	if not id:
		emit_signal("centric_change",true)
	else:
		emit_signal("centric_change",false)

################################################################################
## Changing time signals

func _on_EYear_value_changed(value):
	emit_signal("time_change")

func _on_EMonth_item_selected(id):
	emit_signal("time_change")

func _on_EDay_value_changed(value):
	emit_signal("time_change")

func _on_EHour_value_changed(value):
	emit_signal("time_change")

func _on_EMinute_value_changed(value):
	emit_signal("time_change")
