#version 130

// Attributs
in vec4 vertex;

// Uniform
uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;

invariant gl_Position;

void main ()
{	
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;
}