#version 140

in vec4 vertex;
in vec3 normal;

uniform vec4 in_AmbientLight;
uniform vec4 in_MatAmbient;
uniform vec4 in_MatDiffuse;
uniform vec4 in_MatEmissive;
uniform vec4 in_MatSpecular;
uniform float in_MatShininess;
uniform mat4 ProjectionModelViewMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform vec4 in_LightsPosition[8];
uniform vec4 in_LightsDiffuse[8];
uniform vec4 in_LightsAmbient[8];
uniform vec4 in_LightsSpecular[8];

out vec3 vtx_normal;
out vec3 vtx_vertex;
out vec3 vtx_positions[8];
out vec4 vtx_diffuses[8];
out vec4 vtx_speculars[8];
out vec4 vtx_ambient;
out float vtx_shininess;

void main()
{
	vtx_normal = normalize( NormalMatrix * normal);
	vtx_vertex = normalize( (ModelViewMatrix * vertex).xyz);
	vtx_ambient = in_AmbientLight;
	int i;

	for (i = 0 ; i < 3 ; ++i)
	{
		vtx_positions[i] = normalize( (ModelViewMatrix * in_LightsPosition[i]).xyz);
		vtx_diffuses[i] = in_LightsDiffuse[i] * in_MatDiffuse;
		vtx_ambient += in_LightsAmbient[i];
		vtx_speculars[i] = in_LightsSpecular[i] * in_MatSpecular;
	}

	vtx_ambient = (vtx_ambient * in_MatAmbient) + in_MatAmbient + in_MatEmissive;
	vtx_shininess = in_MatShininess;

	gl_Position = ProjectionModelViewMatrix * vertex;
}