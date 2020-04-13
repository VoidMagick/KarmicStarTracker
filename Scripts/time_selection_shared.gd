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

func _ready():
	get_current_time()
	reset_display_time_to_current()

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
