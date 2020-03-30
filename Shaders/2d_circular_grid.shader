shader_type canvas_item;

// Adjust these artistically
uniform float opacity = 0.5;
uniform vec3 cyan = vec3(0.0,1.0,1.0);
uniform vec3 green = vec3(0.0,1.0,0.0);

// Other constants -- probably do not touch
uniform float PI = 3.1415926;

// Functions

float SMOOTH(float r, float R) {
	return (1.0-smoothstep(R-0.001,R+0.001,r));
}

mat2 rotate2d(float _angle) {
    return mat2(vec2(cos(_angle),-sin(_angle)),vec2(sin(_angle),cos(_angle)));
}

float circle(vec2 uv, vec2 center, float radius, float thk) {
	float r = distance(uv,center);
	return SMOOTH(r-thk/2.0,radius) - SMOOTH(r+thk/2.0,radius);
}

float line(vec2 uv, vec2 center, float angle, float thk) {
	uv -= center;
	uv *= rotate2d(angle*(PI/180.0));
	uv += center;
	float xpos = center.x;
	//vec2 lmask = step(vec2(xpos-thk/2.0,0.0),uv);
	//vec2 rmask = step(vec2(1.0-xpos-thk/2.0,0.0),1.0-uv);
	vec2 lmask = smoothstep(vec2(xpos-thk/2.0-0.0005,0.0),vec2(xpos-thk/2.0+0.0005,0.0),uv);
	vec2 rmask = smoothstep(vec2(1.0-xpos-thk/2.0-0.0005,0.0),vec2(1.0-xpos-thk/2.0+0.0005,0.0),1.0-uv);
	float line = lmask.x * lmask.y * rmask.x * rmask.y;
	return line;
}

// Fragment function

void fragment(){
	// Variables we will return to COLOR at the end
	vec3 finalcolor = vec3(0.0);
	float finalalpha = 1.0;
	
	// Draw a bunch of circles
	float circles = 0.0;
	for (int i=1; i<21; i++){
		circles += circle(UV,vec2(0.5),0.025*float(i),0.001);
	}
	finalcolor += circles * cyan;
	//finalalpha *= circles;
	
	// Draw the radial grid lines
	float lines = 0.0;
	for (int i=0; i<12; i++) {
		lines += line(UV,vec2(0.5,0.5),float(i)*15.0,0.001);
	}
	//float line = line(UV,vec2(0.5,0.5),0.0,0.01);
	finalcolor += lines * cyan;
	//finalalpha *= lines;
	
	// Last touches
	finalalpha *= opacity;
	
	// Finally, let's draw our shader
	COLOR = vec4(finalcolor,finalalpha);
}