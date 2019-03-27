attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_MatAmbient;
uniform vec4 in_MatDiffuse;
uniform vec4 in_MatSpecular;
uniform float in_MatShininess;

varying vec2 texCoord;
varying vec3 eyeSpaceVert;
varying vec3 eyeSpaceTangent;
varying vec3 eyeSpaceBinormal;
varying vec3 eyeSpaceNormal;
varying vec3 eyeSpaceLight;

varying vec4 ex_Light0Ambient;
varying vec4 ex_Light0Diffuse;
varying vec4 ex_Light0Specular;

varying vec4 ex_MatAmbient;
varying vec4 ex_MatDiffuse;
varying vec4 ex_MatSpecular;
varying float ex_MatShininess;

varying int ex_Instance;

float length( vec3 p_vector)
{
	return sqrt( p_vector.x * p_vector.x + p_vector.y * p_vector.y + p_vector.z * p_vector.z);
}

void main(void)
{
	ex_Instance = gl_InstanceID;
	vec3 binormal = cross( tangent, normal);

	eyeSpaceVert = (ModelViewMatrix * vertex).xyz;
	eyeSpaceLight = (ModelViewMatrix * in_LightsPosition[0]).xyz;

	eyeSpaceTangent = NormalMatrix * tangent;
	eyeSpaceBinormal = NormalMatrix * binormal;
	eyeSpaceNormal = NormalMatrix * normal;

	ex_MatAmbient = in_MatAmbient;
	ex_MatDiffuse = in_MatDiffuse;
	ex_MatSpecular = in_MatSpecular;
	ex_MatShininess = in_MatShininess;

	texCoord = MultiTexCoord0;

	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}
