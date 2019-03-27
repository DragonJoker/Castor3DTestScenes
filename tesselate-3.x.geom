#version 150
layout (triangles) in;
layout (triangle_strip, max_vertices = 6) out;

in vec2 vtx_texture[3];
in vec3 vtx_normal[3];
in vec3 vtx_vertex[3];
in vec3 vtx_position[3];
in vec4 vtx_diffuse[3];
in vec4 vtx_specular[3];
in vec4 vtx_ambient[3];
in float vtx_shininess[3];

out vec2 geo_texture;
out vec3 geo_normal;
out vec3 geo_vertex;
out vec3 geo_position;
out vec4 geo_diffuse;
out vec4 geo_specular;
out vec4 geo_ambient;
out float geo_shininess;

void GenerateVertex( in int p_index1, in int p_index2)
{
	gl_Position = 	gl_in[p_index1].gl_Position	+ (gl_in[p_index2].gl_Position	- gl_in[p_index1].gl_Position)	/ 2.0;
	geo_texture = 	vtx_texture[p_index1] 		+ (vtx_texture[p_index2] 		- vtx_texture[p_index1]) 		/ 2.0;
	geo_normal = 	vtx_normal[p_index1] 		+ (vtx_normal[p_index2] 		- vtx_normal[p_index1]) 		/ 2.0;
	geo_vertex = 	vtx_vertex[p_index1] 		+ (vtx_vertex[p_index2] 		- vtx_vertex[p_index1]) 		/ 2.0;
	geo_position = 	vtx_position[p_index1] 		+ (vtx_position[p_index2] 		- vtx_position[p_index1]) 		/ 2.0;
	geo_diffuse = 	vtx_diffuse[p_index1] 		+ (vtx_diffuse[p_index2] 		- vtx_diffuse[p_index1]) 		/ 2.0;
	geo_specular = 	vtx_specular[p_index1] 		+ (vtx_specular[p_index2] 		- vtx_specular[p_index1]) 		/ 2.0;
	geo_ambient = 	vtx_ambient[p_index1] 		+ (vtx_ambient[p_index2] 		- vtx_ambient[p_index1]) 		/ 2.0;
	geo_shininess =	vtx_shininess[p_index1] 	+ (vtx_shininess[p_index2] 		- vtx_shininess[p_index1]) 		/ 2.0;
	EmitVertex();
}

void main()
{
	gl_Position = vec4( 0.0);

	//increment variable
	int i;

	for (i = 0 ; i < 3 ; i++)
	{
		gl_Position = gl_in[i].gl_Position;
		geo_texture = vtx_texture[i];
		geo_normal = vtx_normal[i];
		geo_vertex = vtx_vertex[i];
		geo_position = vtx_position[i];
		geo_diffuse = vtx_diffuse[i];
		geo_specular = vtx_specular[i];
		geo_ambient = vtx_ambient[i];
		geo_shininess = vtx_shininess[i];
		EmitVertex();
	}

	GenerateVertex( 0, 1);
	GenerateVertex( 1, 2);
	GenerateVertex( 2, 0);

	EndPrimitive();

}