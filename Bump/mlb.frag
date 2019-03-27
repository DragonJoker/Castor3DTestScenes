varying vec3 lightVec[3];
varying vec4 lightSpec[3];
varying vec4 lightDiff[3];
varying vec3 viewVec;
varying vec2 TexCoord;

uniform sampler2D DiffuseMap;
uniform sampler2D NormalMap;

varying float ex_MatShininess;
varying vec4 ex_MatDiffuse;

void main( void)
{
	vec2 uv = TexCoord;
	vec4 base = texture2D( DiffuseMap, uv);
	vec4 final_color = vec4( 0.2, 0.2, 0.2, 1.0) * base;
	vec3 vVec = normalize( viewVec);
	vec3 bump = normalize( texture2D( NormalMap, uv).xyz * 2.0 - 1.0);
	vec3 R = reflect( -vVec, bump);
	int i;

	for (i = 0 ; i < 3 ; ++i)
  	{
		vec3 lVec = normalize( lightVec[i]);
		float diffuse = max( dot( lVec, bump), 0.0);
		vec4 vDiffuse = lightDiff[i] * diffuse;
		final_color += vDiffuse;

		float specular = pow( clamp( dot( R, lVec), 0.0, 1.0), ex_MatShininess);
		vec4 vSpecular = lightSpec[i] * specular * diffuse;
		final_color += vSpecular;
	}
	
	final_color = clamp( final_color + (base / 5.0), vec4( 0.0, 0.0, 0.0, 0.0), vec4( 1.0, 1.0, 1.0, 1.0));

	gl_FragColor = final_color;
}