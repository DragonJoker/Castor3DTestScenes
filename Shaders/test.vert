varying vec3 g_colour;

attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;

void main(void)
{
	g_colour = normal;
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}