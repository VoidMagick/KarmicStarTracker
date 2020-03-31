extends Node2D

var d = 0
var ecl = 0
var pi = 3.1415926

### Orbital elements

var Bodies = ["Sun","Moon","Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]
var Planets = ["Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]

### Sprites, Scaling values

var BodySprites = {
	"Earth": "res://Artwork/Icons/Vector/planet_earth.svg",
	"Mercury": "res://Artwork/Icons/Vector/planet_mercury.svg",
	"Venus": "res://Artwork/Icons/Vector/planet_venus.svg",
	"Mars": "res://Artwork/Icons/Vector/planet_mars.svg",
	"Jupiter": "res://Artwork/Icons/Vector/planet_jupiter.svg",
	"Saturn": "res://Artwork/Icons/Vector/planet_saturn.svg",
	"Uranus": "res://Artwork/Icons/Vector/planet_uranus.svg",
	"Neptune": "res://Artwork/Icons/Vector/planet_neptune.svg"
}
var BodyScales = {
	"Earth": 0.40,
	"Mercury": 0.20,
	"Venus": 0.38,
	"Mars": 0.25,
	"Jupiter": 1.00,
	"Saturn": 0.58,
	"Uranus": 0.54,
	"Neptune": 0.60
}
var OrbitScales = {
	"Earth": 100.0,
	"Mercury": 100.0,
	"Venus": 100.0,
	"Mars": 100.0,
	"Jupiter": 35.0,
	"Saturn": 25.0,
	"Uranus": 15.0,
	"Neptune": 15.0
}

### Intialize empty orbits dictionary
var Orbits = {	
	"Sun": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Moon": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Mercury": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Venus": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Mars": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Jupiter": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Saturn": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Uranus": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Neptune": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
}

### Initialize empty position dictionarys
### Relative to the sun, relative to earth, and scaled to draw
var PosRSun = {	
	"Sun": Vector3(0.0,0.0,0.0),
	"Earth": Vector3(0.0,0.0,0.0),
	"Moon": Vector3(0.0,0.0,0.0),
	"Mercury": Vector3(0.0,0.0,0.0),
	"Venus": Vector3(0.0,0.0,0.0),
	"Mars": Vector3(0.0,0.0,0.0),
	"Jupiter": Vector3(0.0,0.0,0.0),
	"Saturn": Vector3(0.0,0.0,0.0),
	"Uranus": Vector3(0.0,0.0,0.0),
	"Neptune": Vector3(0.0,0.0,0.0)
}
var PosREarth = {	
	"Sun": Vector3(0.0,0.0,0.0),
	"Earth": Vector3(0.0,0.0,0.0),
	"Moon": Vector3(0.0,0.0,0.0),
	"Mercury": Vector3(0.0,0.0,0.0),
	"Venus": Vector3(0.0,0.0,0.0),
	"Mars": Vector3(0.0,0.0,0.0),
	"Jupiter": Vector3(0.0,0.0,0.0),
	"Saturn": Vector3(0.0,0.0,0.0),
	"Uranus": Vector3(0.0,0.0,0.0),
	"Neptune": Vector3(0.0,0.0,0.0)
}
var PosDraw = {	
	"Sun": Vector3(0.0,0.0,0.0),
	"Earth": Vector3(0.0,0.0,0.0),
	"Moon": Vector3(0.0,0.0,0.0),
	"Mercury": Vector3(0.0,0.0,0.0),
	"Venus": Vector3(0.0,0.0,0.0),
	"Mars": Vector3(0.0,0.0,0.0),
	"Jupiter": Vector3(0.0,0.0,0.0),
	"Saturn": Vector3(0.0,0.0,0.0),
	"Uranus": Vector3(0.0,0.0,0.0),
	"Neptune": Vector3(0.0,0.0,0.0)
}

func _ready():
	
	## Lets access the functions that get us the info we need
	d = get_time()
	get_orbital_elements(d)
	
	## Create the interface
	interface_centric_selection()
	interface_time_selection()
	
	## Compute obliquity
	ecl = 23.4393 - 0.0000003563*d
	
	## Calculate the sun's position relative to the earth
	PosRSun["Sun"] = find_sun_position(Orbits["Sun"][0],Orbits["Sun"][1],Orbits["Sun"][2],Orbits["Sun"][3],Orbits["Sun"][4],Orbits["Sun"][5])
	#print()
	
	## Reverse sun position to find position of earth relative to run
	PosRSun["Earth"] = (-1.0)*PosRSun["Sun"]
	
	## Calculate body position for all planets (except earth), relative to the sun
	for body in Planets:
		var N = Orbits[body][0]
		var i = Orbits[body][1]
		var w = Orbits[body][2]
		var a = Orbits[body][3]
		var e = Orbits[body][4]
		var M = Orbits[body][5]
		PosRSun[body] = find_body_position(N,i,w,a,e,M)
		draw_body(body,OrbitScales[body],BodySprites[body],BodyScales[body])
	
	## Draw earth
	var body = "Earth"
	draw_body(body,OrbitScales[body],BodySprites[body],BodyScales[body])
	
	pass

func _process(_delta):
	pass

func datetime_to_numtime(yr,mth,dy,hr,mn,sc):
	var numtime = 367*yr - 7*(yr+(mth+9)/12)/4 - 3*((yr+(mth-9)/7)/100+1)/4 + 275*mth/9 + dy - 730515 + (hr+(mn+sc/60.0)/60.0)/24.0
	return numtime

func get_time():
	
	var datetimeDict = OS.get_datetime()
	
	var year = datetimeDict.year
	var month = datetimeDict.month
	var day = datetimeDict.day
	var hour = datetimeDict.hour
	var minute = datetimeDict.minute
	var second = datetimeDict.second
	
	var numtime = datetime_to_numtime(year,month,day,hour,minute,second)
	
	return numtime
	
func get_orbital_elements(dd):
	
	### Values for N, i, w and M (0,1,2,5) are calculated here as degrees
	
	Orbits = {
		
		"Sun": [
			0.0,
			0.0,
			282.9404 + 0.0000470935 * dd,
			1.0,
			0.016709,
			fposmod(356.0470 + 0.9856002585 * dd, 360)
			],
	
		"Moon": [
			125.1228 - 0.0529538083 * dd,
			5.1454,
			fposmod(318.0634 + 0.1643573223 * dd, 360),
			60.2666,
			0.054900,
			fposmod(115.3654 + 13.0649929509 * dd, 360)
			],
	
		"Mercury": [
			48.3313,
			7.0047,
			29.1241,
			0.387098,
			0.205635,
			fposmod(168.6562 + 4.0923344368 * dd, 360)
		],
	
		"Venus": [
			76.6799 + 0.0000246590 * dd,
			3.3946,
			54.8910 + 0.0000138374 * dd,
			0.723330,
			0.006773,
			fposmod(48.0052 + 1.6021302244 * dd, 360)
		],
	
		"Mars": [
			49.5574 + 0.0000211081 * dd,
			1.8497,
			286.5016 + 0.0000292961 * dd,
			1.523688,
			0.093405,
			fposmod(18.6021 + 0.5240207766 * dd, 360)
		],
	
		"Jupiter": [
			100.4542 + 0.0000276854 * dd,
			1.3030,
			273.8777 + 0.0000164505 * dd,
			5.20256,
			0.048498,
			fposmod(19.8950 + 0.0830853001 * dd, 360)
		],
	
		"Saturn": [
			113.6634 + 0.000023898 * dd,
			2.4886,
			339.3939 + 0.0000297661 * dd,
			9.55475,
			0.055546,
			fposmod(316.9670 + 0.0334442282 * dd, 360)
		],
	
		"Uranus": [
			74.0005 + 0.000013978 * dd,
			0.7733,
			96.6612 + 0.000030565 * dd,
			19.18171,
			0.047318,
			fposmod(142.5905 + 0.011725806 * dd, 360)
		],
	
		"Neptune": [
			131.7806 + 0.000030173 * dd,
			1.7700,
			272.8461,
			30.05826,
			0.008606,
			fposmod(260.2471 + 0.005995147 * dd, 360)
		],
		
	}
	
	## Convert degrees values into radians
	
	for body in Bodies:
		for i in [0, 1, 2, 5]:
			Orbits[body][i] = deg2rad(Orbits[body][i])
	
	pass
	
func find_sun_position(_N,_i,w,_a,e,M):
	# Compute the eccentric anomaly of the sun
	var E = M + e * sin(M) * (1.0 + e*cos(M))
	
	# Compute true anomaly
	var xv = cos(E) - e
	var yv = sqrt(1.0 - e*e) * sin(E)
	var v = atan2(yv,xv)
	var r = sqrt(xv*xv + yv*yv)
		
	# Compute longitude
	var lonsun = v + w
	
	# Convert to ecliptic rectangular coordinates
	var xs = r * cos(lonsun)
	var ys = r * sin(lonsun)
	
	var BodyPos = Vector2(xs, ys)
	
	return BodyPos
	
func find_body_position(N,i,w,a,e,M):
	# Compute the eccentric anomaly of the body
	var E = 0
	if e < 0.05:
		E = M + e * sin(M) * (1.0 + e*cos(M))
	else:
		var E0 = M
		var E1 = 0
		while abs(E0-E1) > 0.0001:
			E0 = E1
			E1 = E0 - (E0 - e * sin(E0) - M) / (1 - e*cos(E0))
			#print("E0=",str(E0)," E1=",str(E1))
	
	# Compute true anomaly
	var xv = a * (cos(E) - e)
	var yv = a * (sqrt(1.0 - e*e) * sin(E))
	var v = atan2(yv,xv)
	var r = sqrt(xv*xv + yv*yv)
	
	# Compute the body's position in space
	var xh = r * (cos(N) * cos(v+w) - sin(N) * sin(v+w) * cos(i))
	var yh = r * (sin(N) * cos(v+w) + cos(N) * sin(v+w) * cos(i))
	var _zh = r * (sin(v+w) * sin(i)) # Depth calculated but not used for 2D
	
	var BodyPos = Vector2(xh, yh)
	
	return BodyPos
	
func correct_Jupiter_longitude(longitude,Mj,Ms):
	var corrected_longitude = longitude + \
		-0.332 * sin(2*Mj - 5*Ms - deg2rad(67.6)) \
		-0.056 * sin(2*Mj - 2*Ms + deg2rad(21)) \
		+0.042 * sin(3*Mj - 5*Ms + deg2rad(21)) \
		-0.036 * sin(Mj - 2*Ms) \
		+0.022 * cos(Mj - Ms) \
		+0.023 * sin(2*Mj - 3*Ms + deg2rad(52)) \
		-0.016 * sin(Mj - 5*Ms - deg2rad(69))
	
	return corrected_longitude
	
func correct_Saturn_longitude(longitude,Mj,Ms):
	var corrected_longitude = longitude + \
		+0.812 * sin(2*Mj - 5*Ms - deg2rad(67.6)) \
		-0.229 * cos(2*Mj - 4*Ms - deg2rad(2)) \
		+0.119 * sin(Mj - 2*Ms - deg2rad(3)) \
		+0.046 * sin(2*Mj - 6*Ms - deg2rad(69)) \
		+0.014 * sin(Mj - 3*Ms + deg2rad(32))
	
	return corrected_longitude

func correct_Saturn_latitude(latitude,Mj,Ms):
	var corrected_latitude = latitude + \
		-0.020 * cos(2*Mj - 4*Ms - deg2rad(2)) \
		+0.018 * sin(2*Mj - 6*Ms - deg2rad(49))
	
	return corrected_latitude

func correct_Uranus_longitude(longitude,Mj,Ms,Mu):
	var corrected_longitude = longitude + \
		+0.040 * sin(Ms - 2*Mu + deg2rad(6)) \
		+0.035 * sin(Ms - 3*Mu + deg2rad(33)) \
		-0.015 * sin(Mj - Mu + deg2rad(20))
	
	return corrected_longitude

func draw_body(body,scale,texturepath,bodyscale):
	var BodySprite = Sprite.new()
	BodySprite.set_name(body)
	add_child(BodySprite)
	BodySprite.set_position(PosRSun[body]*scale)
	var BodyTexture = load(texturepath)
	BodySprite.set_texture(BodyTexture)
	BodySprite.set_scale(Vector2(bodyscale,bodyscale))
	pass

func interface_time_selection():
	## Create the first grid container
	var MainDateGrid = GridContainer.new()
	MainDateGrid.set_name("MainDateGrid")
	add_child(MainDateGrid)
	MainDateGrid.set_columns(1)
	MainDateGrid.set_position(Vector2(-500,-500))
	
	## Top of the grid is a combo box
	var ChooseTimeType = OptionButton.new()
	ChooseTimeType.set_name("ChooseTimeType")
	MainDateGrid.add_child(ChooseTimeType)
	ChooseTimeType.add_item("Current Time")
	ChooseTimeType.add_item("Custom Time")
	
	## Bottom is another grid
	var DateSelectGrid = GridContainer.new()
	DateSelectGrid.set_name("DateSelectGrid")
	MainDateGrid.add_child(DateSelectGrid)
	DateSelectGrid.set_columns(5)
	
	for text in ["Year","Month","Day","Hour","Minute"]:
		var newlabel = Label.new()
		newlabel.set_name(text)
		newlabel.set_text(text)
		DateSelectGrid.add_child(newlabel)
	pass

func interface_centric_selection():
	var ChooseCentric = OptionButton.new()
	ChooseCentric.set_name("ChooseCentric")
	ChooseCentric.set_position(Vector2(0,-500))
	add_child(ChooseCentric)
	ChooseCentric.add_item("Heliocentric")
	ChooseCentric.add_item("Geocentric")
	
	pass

func time_current():
	pass
	
func time_custom():
	pass

#func create_calender(StartingYear, EndingYear):
#	var months = ["Jan","Feb","March","Apr","May","June","July","Aug","Sep","Oct","Nov","Dec"]
#	var monthdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
#
#	for year in range(StartingYear, EndingYear):
#		Calender
#	pass
