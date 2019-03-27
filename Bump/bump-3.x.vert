#version 140

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat4 ProjectionModelViewMatrix;
uniform mat3 NormalMatrix;

in vec4 vertex;
in vec3 normal;
in vec3 tangent;
in vec2 texture;

out vec2 TexCoord;
out vec3 textureLight;
out vec3 textureEye;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsSpecular[8];
uniform vec4 in_MatAmbient;
uniform vec4 in_MatDiffuse;
uniform vec4 in_MatSpecular;
uniform float in_MatShininess;

out vec4 ex_Light0Ambient;
out vec4 ex_Light0Diffuse;
out vec4 ex_Light0Specular;

out vec4 ex_MatAmbient;
out vec4 ex_MatDiffuse;
out vec4 ex_MatSpecular;
out float ex_MatShininess;

void main(void)
{
	TexCoord = texture;

	vec3 n = NormalMatrix * normal;
	vec3 t = NormalMatrix * tangent;
	vec3 b = cross( n, t);

	vec3 light = normalize( (ModelViewMatrix * in_LightsPosition[0]).xyz);

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

	gl_Position = ProjectionModelViewMatrix * vertex;
}
