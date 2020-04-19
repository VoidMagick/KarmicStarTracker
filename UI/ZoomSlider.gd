extends VSlider

func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("mouse_scroll_up"):
		change_zoom(-1.0)
	if Input.is_action_pressed("mouse_scroll_down"):
		change_zoom(1.0)

func change_zoom(dir):
	var current = get_value()
	var new = 0
	if current < 0.5:
		new = current + dir * 0.01
	if current < 1:
		new = current + dir * 0.025
	if current < 2:
		new = current + dir * 0.05
	if current < 4:
		new = current + dir * 0.1
	if current <= 8:
		new = current + dir * 0.2
	else:
		new = current
	set_value(new)
