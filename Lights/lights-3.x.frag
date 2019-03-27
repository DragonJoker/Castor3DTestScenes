#version 140

in vec3 eyeVertex;
in vec3 eyeNormal;

in vec3 ex_LightsPosition[8];
in vec4 ex_LightsDiffuse[8];
in vec4 ex_LightsAmbient[8];
in vec4 ex_LightsSpecular[8];

in vec4 ex_MatDiffuse;
in vec4 ex_MatAmbient;
in vec4 ex_MatSpecular;
in vec4 ex_MatEmissive;
in float ex_MatShininess;

out vec4 out_FragColor;

void main()
{
	vec4 final_color = vec4( 0);
	int i;
	vec4 l_ambient;
	vec4 l_diffuse;
    vec4 l_specular;
	int l_iCount = 1;

	for (i = 0 ; i < 3 ; i++)
	{
		l_diffuse = ex_LightsDiffuse[i] * ex_MatDiffuse * max( dot( eyeNormal, ex_LightsPosition[i]), 0.0);
//		l_specular = ex_LightsSpecular[i] * ex_MatSpecular * pow( max( dot( reflect( ex_LightsPosition[i], eyeNormal), eyeVertex), 0.0), ex_MatShininess);
		l_specular = ex_LightsSpecular[i] * ex_MatSpecular * pow( max( dot( normalize( ex_LightsPosition[i] - eyeVertex), eyeNormal), 0.0), ex_MatShininess);
		final_color += l_diffuse + l_specular;
		l_iCount += 1;
	}

	out_FragColor = final_color / l_iCount;
}