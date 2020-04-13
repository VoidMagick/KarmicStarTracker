extends Node

func _ready():
	
	## Centric and Time Change Signal Connection
	var SS = get_node("SystemViewer/ViewportContainer/Viewport/SolarSystem")
	get_node("UI").connect("centric_change",SS,"centric_change")
	get_node("UI").connect("time_change",SS,"time_change")
