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

var timeRangeDict = {}
var Daycount = {1:31,2:28,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31}

var Heliocentric = true
var zoom = 100

func _init():
	#create_timerange_dict()
	get_current_time()
	reset_display_time_to_current()
	compute_d()
	calculate_lonsun()

func create_timerange_dict():
	
	var days = {
		1: 31,
		2: 28,
		3: 31,
		4: 30,
		5: 31,
		6: 30,
		7: 31,
		8: 31,
		9: 30,
		10: 31,
		11: 30,
		12: 31,
	}
	
	var i = 1
	for n_y in range(2000,2011):
		for n_mth in range(1,13):
			for n_d in range(1,(days[n_mth]+1)):
				for n_h in range(0,24):
					for n_min in range(0,60):
						timeRangeDict[i] = [n_y, n_mth, n_d, n_h, n_min]
						i += 1
	print(i)

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

func calculate_lonsun():
	
	var ws = deg2rad(282.9404 + 0.0000470935 * d)
	var es = 0.016709
	var Ms = deg2rad(fposmod(356.0470 + 0.9856002585 * d, 360))
	
	## Find Sun Position Relative to Earth
	
	# Compute the eccentric anomaly of the sun
	var Es = Ms + es * sin(Ms) * (1.0 + es*cos(Ms))
	
	# Compute true anomaly
	var xvs = cos(Es) - es
	var yvs = sqrt(1.0 - es*es) * sin(Es)
	var vs = atan2(yvs,xvs)
	rs = sqrt(xvs*xvs + yvs*yvs)
	
	# Compute longitude
	lonsun = vs + ws

func change_time(step):
	
	var t_year = DYear
	var t_month = DMonth
	var t_day = DDay
	var t_hour = DHour
	var t_minute = DMinute
	
	t_hour += step
	
	## Account for overflow when moving forward in time
	
	if t_hour > 23:
		t_hour -= 24
		t_day += 1
	
	if t_day > Daycount[t_month]:
		t_day = 1
		t_month += 1
	
	if t_month > 12:
		t_month = 1
		t_year += 1
	
	## Account for underflow when moving backwards in time
	
	if t_hour < 0:
		t_day -= 1
		t_hour = 23
	
	if t_day < 1:
		t_month -= 1
		t_day += Daycount[t_month]
	
	if t_month < 1:
		t_year -= 1
		t_month = 12
	
	DYear = t_year
	DMonth = t_month
	DDay = t_day
	DHour = t_hour
	DMinute = t_minute
