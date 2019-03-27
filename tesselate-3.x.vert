#version 140

in vec4 vertex;
in vec3 normal;
in vec2 texture;
in vec3 tangent;

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

out vec2 vtx_texture;
out vec3 vtx_normal;
out vec3 vtx_vertex;
out vec3 vtx_position;
out vec4 vtx_diffuse;
out vec4 vtx_specular;
out vec4 vtx_ambient;
out float vtx_shininess;

void main()
{
	vtx_normal = normalize( NormalMatrix * normal);
	vtx_vertex = normalize( (ModelViewMatrix * vertex).xyz);
	vtx_texture = texture.xy;
	vtx_position = normalize( (ModelViewMatrix * in_LightsPosition[0]).xyz);
	vtx_diffuse = in_LightsDiffuse[0] * in_MatDiffuse;
	vtx_specular = in_LightsSpecular[0] * in_MatSpecular;
	vtx_ambient = (in_AmbientLight + in_LightsAmbient[0] ) * in_MatAmbient + in_MatEmissive;
	vtx_shininess = in_MatShininess;

	gl_Position = ProjectionModelViewMatrix * vertex;
}