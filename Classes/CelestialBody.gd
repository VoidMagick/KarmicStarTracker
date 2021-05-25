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
var astrosign = "error"

var astroSigns = [
	"Libra",
	"Scorpio",
	"Sagittarius",
	"Capricorn",
	"Aquarius",
	"Pisces",
	"Aries",
	"Taurus",
	"Gemini",
	"Cancer",
	"Leo",
	"Virgo",
	"Libra",
]

## Resultant Planetary Information

################################################################################
# Primary Calculations

func _ready():
	
	TimeSelectionShared.compute_d()
	calculate_orbital_elements(d)
	TimeSelectionShared.calculate_lonsun()
	body_update(d,ecl,heliocentric,zoom)

func _init():
	
	add_to_group("CelestialBodies")

################################################################################
# Astronomical Calculations

func calculate_orbital_elements(d):
	pass

func body_update(d,ecl,heliocentric,zoom):
	calculate_orbital_elements(d)
	calculate_position()
	position_body(heliocentric,zoom)
	var norm = _calc_astro_sign(LongREarth)
	astrosign = astroSigns[norm]

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

func _calc_astro_sign(lon):
	var refAngle = 0.027972
	var normalized = int(stepify((lon+PI-refAngle)*6/PI,1))
	return(normalized)

################################################################################
