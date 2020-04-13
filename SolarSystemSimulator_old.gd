extends Node2D


var d = 0
var ecl = 0
var heliocentic = true

var zoom = 50

### Orbital elements

var Bodies = ["Sun","Earth","Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]
var Planets = ["Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]


### Intialize empty orbits dictionary
var Orbits = {	
	"Sun": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Earth": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Moon": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Mercury": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Venus": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Mars": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Jupiter": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Saturn": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Uranus": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"Neptune": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
}
var OrbitScales = {
	"Sun": 100.0,
	"Earth": 100.0,
	"Mercury": 100.0,
	"Venus": 100.0,
	"Mars": 100.0,
	"Jupiter": 35.0,
	"Saturn": 25.0,
	"Uranus": 15.0,
	"Neptune": 15.0
}
var BodyScales = {
	"Sun": 0.80,
	"Earth": 0.20,
	"Mercury": 0.10,
	"Venus": 0.19,
	"Mars": 0.12,
	"Jupiter": 0.50,
	"Saturn": 0.28,
	"Uranus": 0.27,
	"Neptune": 0.30
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
var PosDisplay = {	
	"Sun": Vector2(0.0,0.0),
	"Earth": Vector2(0.0,0.0),
	"Moon": Vector2(0.0,0.0),
	"Mercury": Vector2(0.0,0.0),
	"Venus": Vector2(0.0,0.0),
	"Mars": Vector2(0.0,0.0),
	"Jupiter": Vector2(0.0,0.0),
	"Saturn": Vector2(0.0,0.0),
	"Uranus": Vector2(0.0,0.0),
	"Neptune": Vector2(0.0,0.0)
}
var longlatRSun = {	
	"Sun": Vector2(0.0,0.0),
	"Earth": Vector2(0.0,0.0),
	"Moon": Vector2(0.0,0.0),
	"Mercury": Vector2(0.0,0.0),
	"Venus": Vector2(0.0,0.0),
	"Mars": Vector2(0.0,0.0),
	"Jupiter": Vector2(0.0,0.0),
	"Saturn": Vector2(0.0,0.0),
	"Uranus": Vector2(0.0,0.0),
	"Neptune": Vector2(0.0,0.0)
}
var longlatREarth = {	
	"Sun": Vector2(0.0,0.0),
	"Earth": Vector2(0.0,0.0),
	"Moon": Vector2(0.0,0.0),
	"Mercury": Vector2(0.0,0.0),
	"Venus": Vector2(0.0,0.0),
	"Mars": Vector2(0.0,0.0),
	"Jupiter": Vector2(0.0,0.0),
	"Saturn": Vector2(0.0,0.0),
	"Uranus": Vector2(0.0,0.0),
	"Neptune": Vector2(0.0,0.0)
}

### Date Ranges
var customTimeDict = {
	"Year": range(2000,2020),
	"Month": range(1,13),
	"Day": range(1,32),
	"Hour": range(0,24),
	"Minute": range(0,60),
	"Second": 0.0
}
var DisplayDay = {
	"Year": 2000,
	"Month": 1,
	"Day": 1,
	"Hour": 0,
	"Minute": 0,
	"Second": 0,
}

### Time Zones
var timeZones = {}

func _ready():
	
	## Lets access the functions that get us the info we need
	displayday_to_current()
	d_from_displayday()
	get_orbital_elements(d)
	
	## Compute obliquity
	ecl = 23.4393 - 0.0000003563*d
	
	## Calculate Positions
	findall_pos_longlat()
	
	## Arrange bodies
	draw_system()
	scale_bodies()
	
	## Fill the time zones
	timezones()
	
	pass

func _process(_delta):
	pass
	
func timezones():
	for i in range(-12,-9):
		timeZones[str("UTC-",abs(i),":00")] = i;
	for i in range(-9,0):
		timeZones[str("UTC-0",abs(i),":00")] = i;
	for i in range(0,10):
		timeZones[str("UTC+0",i,":00")] = i;
	for i in range(10,15):
		timeZones[str("UTC+",i,":00")] = i;
	
	var timezoneDict = OS.get_time_zone_info()
	print(str("Bias=",timezoneDict.bias))
	print(str("Name=",timezoneDict.name))
	
func d_from_displayday():
	var yr = DisplayDay["Year"]
	var mth = DisplayDay["Month"]
	var dy = DisplayDay["Day"]
	var hr = DisplayDay["Hour"]
	var mn = DisplayDay["Minute"]
	var sc = DisplayDay["Second"]
	d = 367*yr - 7*(yr+(mth+9)/12)/4 - 3*((yr+(mth-9)/7)/100+1)/4 + 275*mth/9 + dy - 730515 + (hr+(mn+sc/60.0)/60.0)/24.0

func displayday_to_current():
	
	var datetimeDict = OS.get_datetime()
	
	DisplayDay["Year"] = datetimeDict.year
	DisplayDay["Month"] = datetimeDict.month
	DisplayDay["Day"] = datetimeDict.day
	DisplayDay["Hour"] = datetimeDict.hour
	DisplayDay["Minute"] = datetimeDict.minute
	DisplayDay["Second"] = 0.0
	
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
		
		"Earth": [
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0
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
			fposmod(286.5016 + 0.0000292961 * dd, 360),
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
	
func findall_pos_longlat():
	
	## Calculate the sun's position relative to the earth
	find_sun_position()
	
	## Reverse sun position to find position of earth relative to sun
	PosRSun["Earth"] = (-1.0)*PosREarth["Sun"]
	
	# PosRSun and PosREarth for Planets
	for body in Planets:
		find_body_position(body)
		PosREarth[body] = PosRSun[body] - PosRSun["Earth"]	
	
func find_sun_position():
	
	var w = Orbits["Sun"][2]
	var e = Orbits["Sun"][4]
	var M = Orbits["Sun"][5]
	
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
	
	PosREarth["Sun"] = Vector3(xs,ys*cos(ecl),ys*sin(ecl))
	
func find_body_position(body):
	
	var N = Orbits[body][0]
	var i = Orbits[body][1]
	var w = Orbits[body][2]
	var a = Orbits[body][3]
	var e = Orbits[body][4]
	var M = Orbits[body][5]
	
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
		E = E1;
	
	# Compute true anomaly
	var xv = a * (cos(E) - e)
	var yv = a * (sqrt(1.0 - e*e) * sin(E))
	var v = atan2(yv,xv)
	var r = sqrt(xv*xv + yv*yv)
	
	# Compute the body's position in space
	var xh = r * (cos(N) * cos(v+w) - sin(N) * sin(v+w) * cos(i))
	var yh = r * (sin(N) * cos(v+w) + cos(N) * sin(v+w) * cos(i))
	var zh = r * (sin(v+w) * sin(i))
	
	PosRSun[body] = Vector3(xh,yh,zh)
	
	var lonecl = atan2(yh,xh)
	var latecl = atan2(zh,sqrt(xh*xh+yh*yh))
	
	longlatRSun[body] = Vector2(lonecl,latecl)
	
	# Consider perturbations of specific bodies
	correct_Moon_perturbations()
	correct_Jupiter_perturbations()
	correct_Saturn_perturbations()
	correct_Uranus_perturbations()
	
	# Compute geo centric position, including perturbations
	
	pass
	
func correct_Moon_perturbations():
	
	var Ms = Orbits["Sun"][5]
	var Mm = Orbits["Moon"][5]
	var Nm = Orbits["Moon"][0];
	var ws = Orbits["Sun"][2];
	var wm = Orbits["Moon"][2];
	
	var Ls = Ms + ws;		# Mean longitude of the sun (Ns=0)
	var Lm = Mm + wm + Nm	# Mean longitude of the moon
	var D = Lm - Ls			# Mean elongation of the moon
	var F = Lm - Nm			# Argument of latitude for the moon
	
	longlatREarth["Moon"].x = longlatREarth["Moon"].x + \
		deg2rad(-1.274) * sin(Mm - 2*D) + \
		deg2rad(+0.658) * sin(2*D) +  \
		deg2rad(-0.186) * sin(Ms) + \
		deg2rad(-0.059) * sin(2*Mm - 2*D) + \
		deg2rad(-0.057) * sin(Mm - 2*D + Ms) + \
		deg2rad(+0.053) * sin(Mm + 2*D) + \
		deg2rad(+0.046) * sin(2*D - Ms) + \
		deg2rad(+0.041) * sin(Mm - Ms) + \
		deg2rad(-0.035) * sin(D) + \
		deg2rad(-0.031) * sin(Mm + Ms) + \
		deg2rad(-0.015) * sin(2*F - 2*D) + \
		deg2rad(+0.011) * sin(Mm - 4*D)
	
	longlatREarth["Moon"].y = longlatREarth["Moon"].y + \
		deg2rad(-0.173) * sin(F - 2*D) + \
		deg2rad(-0.055) * sin(Mm - F - 2*D) + \
		deg2rad(-0.046) * sin(Mm + F - 2*D) + \
		deg2rad(+0.033) * sin(F + 2*D) + \
		deg2rad(+0.017) * sin(2*Mm + F)

func correct_Jupiter_perturbations():
	
	var Mj = Orbits["Jupiter"][5]
	var Ms = Orbits["Saturn"][5]
	
	longlatRSun["Jupiter"].x = longlatRSun["Jupiter"].x + \
		-0.332 * sin(2*Mj - 5*Ms - deg2rad(67.6)) \
		-0.056 * sin(2*Mj - 2*Ms + deg2rad(21)) \
		+0.042 * sin(3*Mj - 5*Ms + deg2rad(21)) \
		-0.036 * sin(Mj - 2*Ms) \
		+0.022 * cos(Mj - Ms) \
		+0.023 * sin(2*Mj - 3*Ms + deg2rad(52)) \
		-0.016 * sin(Mj - 5*Ms - deg2rad(69))
	
func correct_Saturn_perturbations():
	
	var Mj = Orbits["Jupiter"][5]
	var Ms = Orbits["Saturn"][5]
	
	longlatRSun["Saturn"].x = longlatRSun["Saturn"].x + \
		+0.812 * sin(2*Mj - 5*Ms - deg2rad(67.6)) \
		-0.229 * cos(2*Mj - 4*Ms - deg2rad(2)) \
		+0.119 * sin(Mj - 2*Ms - deg2rad(3)) \
		+0.046 * sin(2*Mj - 6*Ms - deg2rad(69)) \
		+0.014 * sin(Mj - 3*Ms + deg2rad(32))
	
	longlatRSun["Saturn"].y = longlatRSun["Saturn"].y + \
		-0.020 * cos(2*Mj - 4*Ms - deg2rad(2)) \
		+0.018 * sin(2*Mj - 6*Ms - deg2rad(49))

func correct_Uranus_perturbations():
	
	var Mj = Orbits["Jupiter"][5]
	var Ms = Orbits["Saturn"][5]
	var Mu = Orbits["Uranus"][5]
	
	longlatRSun["Uranus"].x = longlatRSun["Uranus"].x + \
		+0.040 * sin(Ms - 2*Mu + deg2rad(6)) \
		+0.035 * sin(Ms - 3*Mu + deg2rad(33)) \
		-0.015 * sin(Mj - Mu + deg2rad(20))
	
func draw_system():
	if heliocentic:
		for body in Bodies:
			PosDisplay[body] = Vector2(PosRSun[body].x*OrbitScales[body]*(zoom/50),PosRSun[body].y*OrbitScales[body]*(zoom/50))			
			get_node(body).set_position(PosDisplay[body])
	else:
		for body in Bodies:
			PosDisplay[body] = Vector2(PosREarth[body].x*OrbitScales[body]*(zoom/50),PosREarth[body].y*OrbitScales[body]*(zoom/50))
			get_node(body).set_position(PosDisplay[body])
	
func scale_bodies():
	for body in Bodies:
		get_node(body).set_scale(Vector2(BodyScales[body],BodyScales[body]))

func zoom_system():
	pass
