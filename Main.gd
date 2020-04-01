extends Node2D

var d = 0
var ecl = 0
var pi = 3.1415926
var heliocentic = true

### Orbital elements

var Bodies = ["Sun","Earth","Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]
var Planets = ["Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]

### Sprites, Scaling values

var BodySprites = {
	"Sun": "res://Artwork/Icons/Vector/planet_sun.svg",
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
	"Sun": 0.50,
	"Earth": 0.40,
	"Mercury": 0.20,
	"Venus": 0.38,
	"Mars": 0.25,
	"Jupiter": 1.00,
	"Saturn": 0.58,
	"Uranus": 0.54,
	"Neptune": 0.60
}
var PlanetColors = {
	"Earth": Vector3(0.5,0.5,0.5),
	"Mercury": Vector3(0.5,0.5,0.5),
	"Venus": Vector3(0.5,0.5,0.5),
	"Mars": Vector3(0.5,0.5,0.5),
	"Jupiter": Vector3(0.5,0.5,0.5),
	"Saturn": Vector3(0.5,0.5,0.5),
	"Uranus": Vector3(0.5,0.5,0.5),
	"Neptune": Vector3(0.5,0.5,0.5)
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

### Initialize empty position dictionarys
### Relative to the sun, relative to earth, and scaled to draw
var PosRSun = {	
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
var PosREarth = {	
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
}
var DisplayDay = {
	"Year": 2000,
	"Month": 1,
	"Day": 1,
	"Hour": 0,
	"Minute": 0,
	"Second": 0,
}

func _ready():
	
	## Create the interface
	interface_centric_selection()
	interface_time_selection()
	
	## Lets access the functions that get us the info we need
	displayday_to_current()
	d_from_displayday()
	get_orbital_elements(d)
	calculate_and_draw_all(d)
	
	## debug only
	#interface_debug_orbit_elements()
	
	pass

func _process(_delta):
	pass

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
	
func fill_PosRSun_PosREarth():
	
	## Calculate the sun's position relative to the earth
	PosREarth["Sun"] = find_sun_position(Orbits["Sun"][0],Orbits["Sun"][1],Orbits["Sun"][2],Orbits["Sun"][3],Orbits["Sun"][4],Orbits["Sun"][5])
	
	## Reverse sun position to find position of earth relative to sun
	PosRSun["Earth"] = (-1.0)*PosREarth["Sun"]
	
	# PosRSun and PosREarth for Planets
	for body in Planets:
		var N = Orbits[body][0]
		var i = Orbits[body][1]
		var w = Orbits[body][2]
		var a = Orbits[body][3]
		var e = Orbits[body][4]
		var M = Orbits[body][5]
		PosRSun[body] = find_body_position(N,i,w,a,e,M)
		PosREarth[body] = PosRSun[body] - PosRSun["Earth"]	
	
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
		E = E1;
	
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
	
func draw_bodies():
	for body in Planets:
		draw_body(body,OrbitScales[body],BodySprites[body],BodyScales[body])
	var body = "Earth"
	draw_body(body,OrbitScales[body],BodySprites[body],BodyScales[body])
	body = "Sun"
	draw_body(body,OrbitScales[body],BodySprites[body],BodyScales[body])
	get_node("Sun").set_material(load("res://Materials/sun.tres"))
	
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
	BodySprite.set_texture(load(texturepath))
	BodySprite.set_scale(Vector2(bodyscale,bodyscale))
	#BodySprite.set_material(load("res://Materials/planet.tres"))
	pass
	
func draw_system():
	if heliocentic:
		for body in Bodies:
			get_node(body).set_position(PosRSun[body]*OrbitScales[body])
	else:
		for body in Bodies:
			get_node(body).set_position(PosREarth[body]*OrbitScales[body])
	
func calculate_and_draw_all(dd):
	
	## Compute obliquity
	ecl = 23.4393 - 0.0000003563*dd
	
	## Calculate Positions
	fill_PosRSun_PosREarth()
	
	## Draw All Bodies
	draw_bodies()
	
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
	ChooseTimeType.connect("item_selected",self,"change_time")
	
	## Bottom is another grid
	var DateSelectGrid = GridContainer.new()
	DateSelectGrid.set_name("DateSelectGrid")
	MainDateGrid.add_child(DateSelectGrid)
	DateSelectGrid.set_columns(5)
	
	interface_time_current()

func interface_time_custom():
	var DateSelectGrid = get_node("MainDateGrid/DateSelectGrid")
	delete_children(DateSelectGrid)
	
	## Labels in grid
	for text in ["Year","Month","Day","Hour","Minute"]:
		var newlabel = Label.new()
		newlabel.set_name(text)
		newlabel.set_text(text)
		DateSelectGrid.add_child(newlabel)
	
	## Option buttons in grid
	for text in ["Year","Month","Day","Hour","Minute"]:
		var newoptionbutton = OptionButton.new()
		newoptionbutton.set_name(str("option",text))
		DateSelectGrid.add_child(newoptionbutton)
		for option in customTimeDict[text]:
			newoptionbutton.add_item(str(option))
		newoptionbutton.connect("item_selected",self,str("customTime",text))
		
func interface_time_current():
	var DateSelectGrid = get_node("MainDateGrid/DateSelectGrid")
	delete_children(DateSelectGrid)
	
	for text in ["Year","Month","Day","Hour","Minute"]:
		var newlabel = Label.new()
		newlabel.set_name(text)
		newlabel.set_text(text)
		DateSelectGrid.add_child(newlabel)
	
	var datetimeDict = OS.get_datetime()
	
	for text in ["year","month","day","hour","minute"]:
		var newlabel = Label.new()
		newlabel.set_name(str("Var",text))
		newlabel.set_text(str(datetimeDict[text]))
		DateSelectGrid.add_child(newlabel)
	
	displayday_to_current()
	d_from_displayday()
		
func customTimeYear(id):
#	print(str("Year: "),customTimeDict["Year"][id])
	DisplayDay["Year"] = customTimeDict["Year"][id]
	d_from_displayday()
	get_orbital_elements(d)
	fill_PosRSun_PosREarth()
	draw_system()
	
func customTimeMonth(id):
#	print(str("Month: "),customTimeDict["Month"][id])
	DisplayDay["Month"] = customTimeDict["Month"][id]
	d_from_displayday()
	get_orbital_elements(d)
	fill_PosRSun_PosREarth()
	draw_system()
	
func customTimeDay(id):
#	print(str("Day: "),customTimeDict["Day"][id])
	DisplayDay["Day"] = customTimeDict["Day"][id]
	d_from_displayday()
	get_orbital_elements(d)
	fill_PosRSun_PosREarth()
	draw_system()
	
func customTimeHour(id):
#	print(str("Hour: "),customTimeDict["Hour"][id])
	DisplayDay["Hour"] = customTimeDict["Hour"][id]
	d_from_displayday()
	get_orbital_elements(d)
	fill_PosRSun_PosREarth()
	draw_system()
	
func customTimeMinute(id):
#	print(str("Minute: "),customTimeDict["Minute"][id])
	DisplayDay["Minute"] = customTimeDict["Minute"][id]
	d_from_displayday()
	get_orbital_elements(d)
	fill_PosRSun_PosREarth()
	draw_system()
	
func interface_centric_selection():
	var ChooseCentric = OptionButton.new()
	ChooseCentric.set_name("ChooseCentric")
	ChooseCentric.set_position(Vector2(0,-500))
	add_child(ChooseCentric)
	ChooseCentric.add_item("Heliocentric")
	ChooseCentric.add_item("Geocentric")
	ChooseCentric.connect("item_selected",self,"change_centric")

func change_centric(id):
	if not id:
		heliocentic = true
	elif id:
		heliocentic = false
	draw_system()

func change_time(id):
	if not id:
		interface_time_current()
	elif id:
		interface_time_custom()
	
func interface_debug_orbit_elements():
	var debuggrid = GridContainer.new()
	debuggrid.set_name("debuggrid")
	add_child(debuggrid)
	debuggrid.set_columns(7)
	debuggrid.set_position(Vector2(-500,300))
	for label in [" ","N","i","w","a","e","M"]:
		var newlabel = Label.new()
		newlabel.set_name(label)
		newlabel.set_text(label)
		debuggrid.add_child(newlabel)
	for planet in Planets:
		var newlabel = Label.new()
		newlabel.set_name(str("Label",planet))
		newlabel.set_text(planet)
		debuggrid.add_child(newlabel)
		for i in range(0,6):
			var newnewlabel = Label.new()
			newnewlabel.set_name(str(planet,"_",i))
			newnewlabel.set_text(str(Orbits[planet][i]))
			debuggrid.add_child(newnewlabel)
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


