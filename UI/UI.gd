extends Control

signal centric_change(heliocentric)
signal time_change()
signal zoom_change(zoom)
signal play_simulation()
signal stop_simulation()

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
	TimeSelectionShared.DMonth = id + 1
	print("month is ",TimeSelectionShared.DMonth)
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

################################################################################
## Changing display signals

func _on_ZoomSlider_value_changed(zoom):
	emit_signal("zoom_change",zoom)

################################################################################
## Simulation playing signals

func _on_Rewind_pressed():
	emit_signal("play_simulation",-1)

func _on_Pause_pressed():
	emit_signal("stop_simulation")

func _on_Play_pressed():
	emit_signal("play_simulation",1)

func _on_Fast_pressed():
	emit_signal("play_simulation",2)
