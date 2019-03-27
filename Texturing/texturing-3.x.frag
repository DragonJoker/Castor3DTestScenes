#version 140

in vec2 ex_texture;

uniform sampler2D DiffuseMap;

out vec4 out_FragColor;

void main()
{
	out_FragColor = texture2D( DiffuseMap, ex_texture);
}