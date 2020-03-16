extends Control

var numtime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func datetime_to_numtime(yr,mth,day,hr,mn,sc):
	numtime = 367*yr - 7 * (yr+(mth+9)/12) / 4 - 3 * ((yr+(mth-9)/7)/100+1) / 4 + 275*mth/9 + day - 730515 + (hr+(mn+sc/60)/60)/60
	return numtime

