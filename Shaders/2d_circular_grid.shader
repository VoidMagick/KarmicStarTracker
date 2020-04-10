shader_type canvas_item;

// Adjust these artistically
uniform float opacity = 0.5;
uniform vec3 cyan = vec3(0.0,1.0,1.0);
uniform vec3 green = vec3(0.0,1.0,0.0);

// Other constants -- probably do not touch
uniform float PI = 3.1415926;

// Functions

float SMOOTH(float f, float thk, float smth) {
	return smoothstep(1.0-thk-smth,1.0-thk+smth,f);
}

mat2 rotate2d(float _angle) {
    return mat2(vec2(cos(_angle),-sin(_angle)),vec2(sin(_angle),cos(_angle)));
}

float circles(vec2 uv, vec2 center, float amp, float thk, float smth) {
	return SMOOTH(cos(distance(uv,center)*4.*PI*amp),thk,smth);
}

int radialStep(vec2 uv, vec2 center, float r) {
	float rdist = distance(uv,center);
	int ftest = int(floor(rdist/r+0.05))+1;
	return ftest;
}

float radialstipes(vec2 uv, vec2 center, float amp, float thk, float smth) {
	vec2 pos = center - uv;
	float a = (atan(pos.y,pos.x)+PI) / (2.*PI);
	return SMOOTH(sin(a*2.*PI*15.*float(radialStep(uv,center,(0.5/amp)))),thk,smth);
}

float dashcircles(vec2 uv, vec2 center, float amp, float thk, float smth) {
	float circles = circles(uv, center, amp, thk, smth);
	float dashes = radialstipes(uv, center, amp, 1.0, 0.2);
	return clamp(circles - dashes,0.0,1.0);
}

float lines(vec2 uv, vec2 center, int num, float thk, float smth) {
	float lines = 0.0;
	for (int i=0; i<num; i++) {
		uv -= center;
		uv *= rotate2d(PI/float(num));
		uv += center;
		float xpos = center.x;
		vec2 lmask = smoothstep(vec2(xpos-thk-smth,0.0),vec2(xpos-thk+smth,0.0),uv);
		vec2 rmask = smoothstep(vec2(1.0-xpos-thk-smth,0.0),vec2(1.0-xpos-thk+smth,0.0),1.0-uv);
		lines += lmask.x * lmask.y * rmask.x * rmask.y;
	}
	return lines;
}

float dashlines(vec2 uv, vec2 center, int num, float thk, float smth) {
	float lines = lines(uv,center,num,thk,smth);
	float circles = circles(uv,center,16., 1.0, 0.1);
	return clamp(lines - circles,0.0,1.0);
}

// Fragment function

void fragment() {
	// Variables we will return to COLOR at the end
	vec3 finalcolor = vec3(0.0);
	float finalalpha = 1.0;
	
	// Draw dashed circles in the grid
	float dashcircles = dashcircles(UV, vec2(0.5), 4., 0.0004, 0.001);
	finalcolor += dashcircles;
	
	// Draw dashed lines
	float dashlines = dashlines(UV, vec2(0.5),6,0.0005,0.0008);
	finalcolor += dashlines;
	
	// Finally, let's draw our shader
	finalalpha = finalcolor.r;
	finalcolor *= cyan;
	COLOR = vec4(finalcolor,finalalpha);
}