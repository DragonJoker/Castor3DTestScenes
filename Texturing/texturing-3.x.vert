#version 140

in vec4 vertex;
in vec2 texture;

uniform mat4 ProjectionModelViewMatrix;

out vec2 ex_texture;

void main()
{
	ex_texture = texture.xy;

	gl_Position = ProjectionModelViewMatrix * vertex;
}