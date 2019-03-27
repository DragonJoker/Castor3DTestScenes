#version 140

in vec3 vtx_normal;
in vec3 vtx_vertex;
in vec3 vtx_positions[8];
in vec4 vtx_diffuses[8];
in vec4 vtx_speculars[8];
in vec4 vtx_ambient;
in float vtx_shininess;

out vec4 out_FragColor;

void main()
{
	out_FragColor = vtx_ambient;
	int i;
	vec4 l_diffuse;
    vec4 l_specular;
	int l_iCount = 1;

	for (i = 0 ; i < 3 ; i++)
	{
		l_diffuse = vtx_diffuses[i] * max( dot( vtx_positions[i], vtx_normal), 0.0);
		l_specular = vtx_speculars[i] * pow( max( dot( normalize( vtx_positions[i] - vtx_vertex), vtx_normal), 0.0), vtx_shininess);
		out_FragColor += l_diffuse + l_specular;
		l_iCount += 1;
	}

	out_FragColor /= l_iCount;
}