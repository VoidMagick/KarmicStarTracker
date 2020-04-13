extends SpinBox

func _ready():
	control_reset()

func control_reset():
	TimeSelectionShared.get_current_time()
	set_value(TimeSelectionShared.CYear)

