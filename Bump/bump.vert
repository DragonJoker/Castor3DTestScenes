uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;

attribute vec4 vertex;
attribute vec3 normal;
attribute vec3 tangent;
attribute vec2 MultiTexCoord0;

varying vec2 TexCoord;
varying vec3 textureLight;
varying vec3 textureEye;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsSpecular[8];
uniform vec4 in_MatAmbient;
uniform vec4 in_MatDiffuse;
uniform vec4 in_MatSpecular;
uniform float in_MatShininess;

varying vec4 ex_Light0Ambient;
varying vec4 ex_Light0Diffuse;
varying vec4 ex_Light0Specular;

varying vec4 ex_MatAmbient;
varying vec4 ex_MatDiffuse;
varying vec4 ex_MatSpecular;
varying float ex_MatShininess;

void main(void)
{
	TexCoord = MultiTexCoord0;

	vec3 n = (ModelViewMatrix * vec4(normal, 0.0)).xyz;
	vec3 t = (ModelViewMatrix * vec4(tangent, 0.0)).xyz;
	vec3 b = cross( n, t);

	vec3 light = normalize( in_LightsPosition[1].xyz);

	textureLight.x = dot(light, t);
	textureLight.y = dot(light, b);
	textureLight.z = dot(light, n);
	
	vec3 eye = (ModelViewMatrix * vertex).xyz;
	eye = normalize(-eye);
	
	textureEye.x = dot(eye, t);
	textureEye.y = dot(eye, b);
	textureEye.z = dot(eye, n);

	ex_MatAmbient = in_MatAmbient;
	ex_MatDiffuse = in_MatDiffuse;
	ex_MatSpecular = in_MatSpecular;
	ex_MatShininess = in_MatShininess;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
