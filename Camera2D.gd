extends Camera2D

func _ready():
	pass

func zoom_change(zoom):
	set_zoom(Vector2(zoom,zoom))
