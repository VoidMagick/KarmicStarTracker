extends Node2D

### Variables for scaling appearance
var ScaleOrbit = 200

var year = 0
var month = 0
var day = 0
var hour = 0
var minute = 0
var second = 0

var d = 0
var pi = 3.1415926

### Orbital elements

var Bodies = ["Sun","Moon","Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]
var InnerBodies = ["Mercury","Venus","Mars"]

###

var BodyPos = Vector2(0, 0)

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

### Initialize empty position dictionary
var Positions = {	
	"Sun": Vector2(0.0, 0.0),
	"Earth": Vector2(0.0, 0.0),
	"Moon": Vector2(0.0, 0.0),
	"Mercury": Vector2(0.0, 0.0),
	"Venus": Vector2(0.0, 0.0),
	"Mars": Vector2(0.0, 0.0),
	"Jupiter": Vector2(0.0, 0.0),
	"Saturn": Vector2(0.0, 0.0),
	"Uranus": Vector2(0.0, 0.0),
	"Neptune": Vector2(0.0, 0.0)
}

func _ready():
	
	## Lets access the functions that get us the info we need
	d = get_time()
	get_orbital_elements(d)
	
	## Calculate body positions for inner planets (except earth)
	for body in InnerBodies:
		Positions[body] = find_body_position(Orbits[body][0],Orbits[body][1],Orbits[body][2],Orbits[body][3],Orbits[body][4],Orbits[body][5])
		Positions[body] = Positions[body] * ScaleOrbit
		print(body," x=",Positions[body][0]," ",body," y=",Positions[body][1])
	
	## Move planet sprites to their correct positions	
	$Mercury.set_position(Positions["Mercury"])
	$Venus.set_position(Positions["Venus"])
	$Mars.set_position(Positions["Mars"])
	
	pass

func _process(_delta):
	pass

func datetime_to_numtime(yr,mth,day,hr,mn,sc):
	var numtime = 367*yr - 7*(yr+(mth+9)/12)/4 - 3*((yr+(mth-9)/7)/100+1)/4 + 275*mth/9 + day - 730515 + (hr+(mn+sc/60.0)/60.0)/24.0
	return numtime

func get_time():
	
	var datetimeDict = OS.get_datetime()
	
	year = datetimeDict.year
	month = datetimeDict.month
	day = datetimeDict.day
	hour = datetimeDict.hour
	minute = datetimeDict.minute
	second = datetimeDict.second
	
	$"/root/Scene/CurrentDateTime/VarYear".set_text(str(year))
	$"/root/Scene/CurrentDateTime/VarMonth".set_text(str(month))
	$"/root/Scene/CurrentDateTime/VarDay".set_text(str(day))
	$"/root/Scene/CurrentDateTime/VarHour".set_text(str(hour))
	$"/root/Scene/CurrentDateTime/VarMinute".set_text(str(minute))
	$"/root/Scene/CurrentDateTime/VarSecond".set_text(str(second))
	
	var numtime = datetime_to_numtime(year,month,day,hour,minute,second)
	
	return numtime
	
func get_orbital_elements(d):
	
	### Values for N, i, w and M (0,1,2,5) are calculated here as degrees
	
	Orbits = {
		
		"Sun": [
			0.0,
			0.0,
			282.9404 + 0.0000470935 * d,
			1.0,
			0.016709,
			fposmod(356.0470 + 0.9856002585 * d, 360)
			],
	
		"Moon": [
			125.1228 - 0.0529538083 * d,
			5.1454,
			fposmod(318.0634 + 0.1643573223 * d, 360),
			60.2666,
			0.054900,
			fposmod(115.3654 + 13.0649929509 * d, 360)
			],
	
		"Mercury": [
			48.3313,
			7.0047,
			29.1241,
			0.387098,
			0.205635,
			fposmod(168.6562 + 4.0923344368 * d, 360)
		],
	
		"Venus": [
			76.6799 + 0.0000246590 * d,
			3.3946,
			54.8910 + 0.0000138374 * d,
			0.723330,
			0.006773,
			fposmod(48.0052 + 1.6021302244 * d, 360)
		],
	
		"Mars": [
			49.5574 + 0.0000211081 * d,
			1.8497,
			286.5016 + 0.0000292961 * d,
			1.523688,
			0.093405,
			fposmod(18.6021 + 0.5240207766 * d, 360)
		],
	
		"Jupiter": [
			100.4542 + 0.0000276854 * d,
			1.3030,
			273.8777 + 0.0000164505 * d,
			5.20256,
			0.048498,
			fposmod(19.8950 + 0.0830853001 * d, 360)
		],
	
		"Saturn": [
			113.6634 + 0.000023898 * d,
			2.4886,
			339.3939 + 0.0000297661 * d,
			9.55475,
			0.055546,
			fposmod(316.9670 + 0.0334442282 * d, 360)
		],
	
		"Uranus": [
			74.0005 + 0.000013978 * d,
			0.7733,
			96.6612 + 0.000030565 * d,
			19.18171,
			0.047318,
			fposmod(142.5905 + 0.011725806 * d, 360)
		],
	
		"Neptune": [
			131.7806 + 0.000030173 * d,
			1.7700,
			272.8461,
			30.05826,
			0.008606,
			fposmod(260.2471 + 0.005995147 * d, 360)
		],
		
	}
	
	## Convert degrees values into radians
	
	for body in Bodies:
		for i in [0, 1, 2, 5]:
			Orbits[body][i] = deg2rad(Orbits[body][i])
	
	pass
	
func find_sun_position(N,i,w,a,e,M):
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
	
	#print("xs=",xs)
	#print("ys=",ys)
	pass
	
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
	var zh = r * (sin(v+w) * sin(i)) # Depth calculated but not used for 2D
	
	var BodyPos = Vector2(xh, yh)
	
	return BodyPos


#func create_calender(StartingYear, EndingYear):
#	var months = ["Jan","Feb","March","Apr","May","June","July","Aug","Sep","Oct","Nov","Dec"]
#	var monthdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
#
#	for year in range(StartingYear, EndingYear):
#		Calender
#	pass
