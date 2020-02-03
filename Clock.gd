extends Node2D


var time_seconds = null
var time_minutes = null
var time_hour = null
var time_day = null
var time_month = null
var time_year = null


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_seconds = OS.get_datetime()["second"]
	time_minutes = OS.get_datetime()["minute"]
	time_hour = OS.get_datetime()["hour"]
	time_day = OS.get_datetime()["day"]
	time_month = OS.get_datetime()["month"]
	time_year = OS.get_datetime()["year"]
	pass
