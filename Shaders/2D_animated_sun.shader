shader_type canvas_item;

// Adjust these artistically
uniform vec3 yellow1 = vec3(1.0,0.9,0.4);
uniform vec3 orange1 = vec3(1.0,0.9,0.4);
uniform vec3 red1 = vec3(1.0,0.3,0.2);
uniform float sun_radius = 0.25;
uniform float sun_corona_length = 0.02;

// Other constants -- probably do not touch
uniform float PI = 3.1415926;

void fragment(){
	vec3 finalcolor = vec3(0.0);
	float finalalpha = 1.0;
	
	// Position of each pixel from the center as a percentage
	float pct = distance(UV,vec2(0.5));
	
	// Drawing the basic sun circle
	float sun = smoothstep(sun_radius+sun_corona_length,sun_radius-sun_corona_length,pct);
	finalcolor += vec3(sun)*yellow1;
	finalalpha = sun;
	
	// Add some more sun glow
	float corona = smoothstep(sun_radius+0.2,sun_radius,pct)*0.7;
	finalcolor += vec3(corona)*orange1;
	finalalpha += corona;
	
	// WAVE FUNCTION #1
	float amp = 7.0;	// wave function amplitude
	float scale = 0.025;	// scaling of the wave circle
	float thickness = 0.001;
	
	vec2 position = UV - 0.5;
	float anglepos = atan(position.y,position.x);
	
	float wavefunc1 = (pct - (16.0 + amp*sin(anglepos*16.0-TIME*1.0)*cos(anglepos*12.0-TIME*1.5)*sin(anglepos*20.0+TIME*2.0)*cos(anglepos*27.0+TIME*0.2)) * scale);
	float smoothwave1 = (1.0 - smoothstep(thickness,thickness*100.0,wavefunc1))*0.5;
	finalcolor += vec3(smoothwave1)*red1;
	finalalpha += smoothwave1;
	
	// Color that baby up
	//finalcolor *= sun_color;
	COLOR = vec4(finalcolor,finalalpha);
}