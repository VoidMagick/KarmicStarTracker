extends OptionButton

func _ready():
	control_reset()

func control_reset():
	TimeSelectionShared.get_current_time()
	select(TimeSelectionShared.CMonth - 1)

func control_update():
	select(TimeSelectionShared.DMonth - 1)
