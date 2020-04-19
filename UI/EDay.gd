extends SpinBox

func _ready():
	control_reset()

func control_reset():
	TimeSelectionShared.get_current_time()
	set_value(TimeSelectionShared.CDay)
	control_set_maxrange()

func control_update():
	set_value(TimeSelectionShared.DDay)
	control_set_maxrange()

func control_set_maxrange():
	var month = TimeSelectionShared.DMonth
	var maxdays = TimeSelectionShared.Daycount[month]
	print(maxdays)
	set_max(maxdays)
