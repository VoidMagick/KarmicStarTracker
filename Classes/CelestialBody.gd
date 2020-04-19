extends Sprite

## Editable input variables

export var orbitscale = 1

## Variables that will be inherited

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

var d = TimeSelectionShared.d
var ecl = TimeSelectionShared.ecl
var heliocentric = TimeSelectionShared.Heliocentric
var zoom = TimeSelectionShared.zoom

var rs = 0
var lonsun = 0

func _ready():
	
	TimeSelectionShared.compute_d()
	calculate_orbital_elements(d)
	calculate_lonsun()
	body_update(d,ecl,heliocentric,zoom)

func _init():
	
	add_to_group("CelestialBodies")

################################################################################
# Astronomical Calculations

func calculate_orbital_elements(d):
	pass

func calculate_lonsun():
	
	d = TimeSelectionShared.d
	
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

func body_update(d,ecl,heliocentric,zoom):
	calculate_orbital_elements(d)
	calculate_position()
	position_body(heliocentric,zoom)

func calculate_position():
	consider_perturbations()
	pass

func consider_perturbations():
	pass

func position_body(heliocentric,zoom):
	zoom = 100 ## zoom with this method is disabled for now
	if heliocentric:
		set_position(Vector2(PosRSun.x*orbitscale*(zoom/100),
							PosRSun.y*orbitscale*(zoom/100)))
	else:
		set_position(Vector2(PosREarth.x*orbitscale*(zoom/100),
							PosREarth.y*orbitscale*(zoom/100)))

################################################################################
