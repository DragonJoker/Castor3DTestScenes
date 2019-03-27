#version 140

in vec3 tangent;
in vec4 vertex;
in vec3 normal;
in vec2 texture;

uniform mat4 ProjectionModelViewMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsSpecular[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_AmbientLight;
uniform vec4 in_MatAmbient;
uniform vec4 in_MatDiffuse;
uniform vec4 in_MatSpecular;
uniform float in_MatShininess;

out vec2 ex_TexCoord;
out vec3 ex_EyeSpaceVert;
out vec3 ex_EyeSpaceTangent;
out vec3 ex_EyeSpaceBinormal;
out vec3 ex_EyeSpaceNormal;
out vec3 ex_EyeSpaceLight;

out vec4 ex_AmbientLight;
out vec4 ex_MatAmbient;
out vec4 ex_MatDiffuse;
out vec4 ex_MatSpecular;
out float ex_MatShininess;
out vec4 ex_LightSpecular;
out vec4 ex_LightDiffuse;
out vec4 ex_LightAmbient;

float length( vec3 p_vector)
{
	return sqrt( p_vector.x * p_vector.x + p_vector.y * p_vector.y + p_vector.z * p_vector.z);
}

void main()
{
	vec3 binormal = cross( tangent, normal);

	ex_EyeSpaceTangent = NormalMatrix * tangent;
	ex_EyeSpaceBinormal = NormalMatrix * binormal;
	ex_EyeSpaceNormal = NormalMatrix * normal;

	ex_AmbientLight = in_AmbientLight;
	ex_MatAmbient = in_MatAmbient;
	ex_MatDiffuse = in_MatDiffuse;
	ex_MatSpecular = in_MatSpecular;
	ex_MatShininess = in_MatShininess;

	ex_TexCoord = texture.xy;
	
	ex_LightSpecular = vec4( 0.0);
	ex_LightDiffuse = vec4( 0.0);
	ex_LightAmbient = vec4( 0.0);

	ex_EyeSpaceVert = (ModelViewMatrix * vertex).xyz;
	ex_EyeSpaceLight = (ModelViewMatrix * in_LightsPosition[0]).xyz;

	ex_LightSpecular += in_LightsSpecular[0] * in_MatSpecular;
	ex_LightDiffuse += in_LightsDiffuse[0] * in_MatDiffuse;
	ex_LightAmbient += in_LightsAmbient[0] * in_MatAmbient;

	gl_Position = ProjectionModelViewMatrix * vertex;
}
