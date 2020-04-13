extends Control

signal centric_change(heliocentric)
signal time_change()

func _ready():
	pass

################################################################################
## Changing centric signals

func _on_ChooseCentric_item_selected(id):
	if not id:
		TimeSelectionShared.Heliocentric = true
		emit_signal("centric_change",true)
	else:
		TimeSelectionShared.Heliocentric = false
		emit_signal("centric_change",false)

################################################################################
## Changing time signals

func _on_EYear_value_changed(value):
	TimeSelectionShared.DYear = value
	emit_signal("time_change")

func _on_EMonth_item_selected(id):
	TimeSelectionShared.DMonth = id
	emit_signal("time_change")

func _on_EDay_value_changed(value):
	TimeSelectionShared.DDay = value
	emit_signal("time_change")

func _on_EHour_value_changed(value):
	TimeSelectionShared.DHour = value
	emit_signal("time_change")

func _on_EMinute_value_changed(value):
	TimeSelectionShared.DMinute = value
	emit_signal("time_change")
