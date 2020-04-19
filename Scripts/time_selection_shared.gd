extends Node

var CYear = 0
var CMonth = 0
var CDay = 0
var CHour = 0
var CMinute = 0

var DYear = 0
var DMonth = 0
var DDay = 0
var DHour = 0
var DMinute = 0

var d = 0
var ecl = 0
var lonsun = 0
var rs = 0

var Heliocentric = true
var zoom = 100

func _init():
	get_current_time()
	reset_display_time_to_current()
	compute_d()

func get_current_time():
	
	var datetimeDict = OS.get_datetime()
	
	CYear = datetimeDict.year
	CMonth = datetimeDict.month
	CDay = datetimeDict.day
	CHour = datetimeDict.hour
	CMinute = datetimeDict.minute

func reset_display_time_to_current():
	
	DYear = CYear
	DMonth = CMonth
	DDay = CDay
	DHour = CHour
	DMinute = CMinute

func compute_d():
	
	var yr = DYear
	var mth = DMonth
	var dy = DDay
	var hr = DHour
	var mn = DMinute
	var sc = 0
	d = 367*yr - 7*(yr+(mth+9)/12)/4 - 3*((yr+(mth-9)/7)/100+1)/4 + 275*mth/9 + dy - 730515 + (hr+(mn+sc/60.0)/60.0)/24.0
	ecl = 23.4393 - 0.0000003563*d
