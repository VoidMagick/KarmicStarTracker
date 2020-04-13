extends Sprite

## Signals

signal centricity_changed(previous, new)
signal year_changed()
signal month_changed()
signal day_changed()
signal hour_changed()
signal minute_changed()

## Editable input variables

export var Year: int = 2020
export var Month: int = 4
export var Day: int = 12
export var Hour: int = 21
export var Minute: int = 0

export var Heliocentric: bool = true

export var orbitscale = 1

## Variables that will be inherited

var d: float = 0.0
var ecl: float = 0.0

var PosREarth = Vector3(0,0,0)
var LongREarth = 0
var LatREarth = 0
var PosRSun = Vector3(0,0,0)
var LongRSun = 0
var LatRSun = 0


## Orbital Elements

var N: float = 0.0
var i: float = 0.0
var w: float = 0.0
var a: float = 0.0
var e: float = 0.0
var M: float = 0.0

func _ready():
	
	compute_d()
	calculate_orbital_elements(d)
	body_update(d,ecl,Heliocentric)

func _init():
	
	add_to_group("CelestialBodies")
	
#	connect("centricity_changed",self,"_on_centricity_changed")
#	connect("year_changed",self,"_on_year_change")
#	connect("month_changed",self,"_on_month_change")
#	connect("day_changed",self,"_on_day_change")
#	connect("hour_changed",self,"_on_hour_change")
#	connect("minute_changed",self,"_on_minute_change")

################################################################################
# Astronomical Calculations

func compute_d():
	var yr = Year
	var mth = Month
	var dy = Day
	var hr = Hour
	var mn = Minute
	var sc = 0
	d = 367*yr - 7*(yr+(mth+9)/12)/4 - 3*((yr+(mth-9)/7)/100+1)/4 + 275*mth/9 + dy - 730515 + (hr+(mn+sc/60.0)/60.0)/24.0
	ecl = 23.4393 - 0.0000003563*d

func calculate_orbital_elements(d):
	pass

func body_update(d,ecl,heliocentric):
	calculate_position(d,ecl)
	position_body(heliocentric)

func calculate_position(d,ecl):
	consider_perturbations()
	pass

func consider_perturbations():
	pass

func position_body(heliocentric):
	if heliocentric:
		set_position(Vector2(PosRSun.x*orbitscale,PosRSun.y*orbitscale))
	else:
		set_position(Vector2(PosREarth.x*orbitscale,PosREarth.y*orbitscale))

################################################################################
# Signal Functions

#func _on_centricity_changed(previous, new):
#	compute_d()
#	body_update(d,ecl,Heliocentric)
#
#func _on_year_changed():
#	compute_d()
#	body_update(d,ecl,Heliocentric)
#
#func _on_month_changed():
#	compute_d()
#	body_update(d,ecl,Heliocentric)
#
#func _on_day_changed():
#	compute_d()
#	body_update(d,ecl,Heliocentric)
#
#func _on_hour_changed():
#	compute_d()
#	body_update(d,ecl,Heliocentric)
#
#func _on_minute_changed():
#	compute_d()
#	body_update(d,ecl,Heliocentric)
