extends Control

var year = 0
var month = 0
var day = 0
var hour = 0
var minute = 0
var second = 0

var numtime = 0
var numbertime = 0

func _ready():
	pass

func _process(_delta):
	time()
	update()

func datetime_to_numtime(yr,mth,day,hr,mn,sc):
	numtime = 367*yr - 7*(yr+(mth+9)/12)/4 - 3*((yr+(mth-9)/7)/100+1)/4 + 275*mth/9 + day - 730515 + (hr+(mn+sc/60.0)/60.0)/24.0
	return numtime

func time():
	var datetimeDict = OS.get_datetime()
	
	year = datetimeDict.year
	month = datetimeDict.month
	day = datetimeDict.day
	hour = datetimeDict.hour
	minute = datetimeDict.minute
	second = datetimeDict.second
	
	$VarYear.set_text(str(year))
	$VarMonth.set_text(str(month))
	$VarDay.set_text(str(day))
	$VarHour.set_text(str(hour))
	$VarMinute.set_text(str(minute))
	$VarSecond.set_text(str(second))
	
	numbertime = datetime_to_numtime(year,month,day,hour,minute,second)
	
	$VarNumTime.set_text(str(numbertime))
