#version 150

in vec2 geo_texture;
in vec3 geo_normal;
in vec3 geo_vertex;
in vec3 geo_position;
in vec4 geo_diffuse;
in vec4 geo_specular;
in vec4 geo_ambient;
in float geo_shininess;

//uniform sampler2D in_Texture;

out vec4 out_FragColor;

void main()
{
	vec4 final_color = geo_ambient;// + texture2D( in_Texture, geo_texture);
	vec4 l_diffuse;
    vec4 l_specular;

	l_diffuse = geo_diffuse * max( dot( geo_position, geo_normal), 0.0);
	l_specular = geo_specular * pow( max( dot( normalize( geo_position - geo_vertex), geo_normal), 0.0), geo_shininess);
	final_color += l_diffuse + l_specular;

	out_FragColor = final_color;
}