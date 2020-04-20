extends Node

func _ready():
	
	## Solar System Simulation and Display Connections
	
	var SS = get_node("SystemViewer/ViewportContainer/Viewport/SolarSystem")
	get_node("UI").connect("centric_change",SS,"centric_change")
	get_node("UI").connect("time_change",SS,"time_change")
	get_node("UI").connect("play_simulation",SS,"play_simulation")
	get_node("UI").connect("stop_simulation",SS,"stop_simulation")
	
	## System viewer connections
	
	var camera = get_node("SystemViewer/ViewportContainer/Viewport/Camera2D")
	get_node("UI").connect("zoom_change",camera,"zoom_change")
	
	## Static viewport connections
	var grid = get_node("SystemViewer/ViewportContainer/FixedViewport/GridShader")
	get_node("UI").connect("toggle_grid",grid,"toggle_grid")
	
	## Connecting simulation back to UI
	
	var control_year = get_node("UI/MarginContainer/VBoxContainer/TopContainer/TimeSelectionContainer/TimeGrid/EYear")
	var control_month = get_node("UI/MarginContainer/VBoxContainer/TopContainer/TimeSelectionContainer/TimeGrid/EMonth")
	var control_day = get_node("UI/MarginContainer/VBoxContainer/TopContainer/TimeSelectionContainer/TimeGrid/EDay")
	var control_hour = get_node("UI/MarginContainer/VBoxContainer/TopContainer/TimeSelectionContainer/TimeGrid/EHour")
	var control_minute = get_node("UI/MarginContainer/VBoxContainer/TopContainer/TimeSelectionContainer/TimeGrid/EMinute")
	
	SS.connect("update_ui_time",control_year,"control_update")
	SS.connect("update_ui_time",control_month,"control_update")
	SS.connect("update_ui_time",control_day,"control_update")
	SS.connect("update_ui_time",control_hour,"control_update")
	SS.connect("update_ui_time",control_minute,"control_update")
	
	get_node("UI").connect("month_change",control_day,"control_set_maxrange")
