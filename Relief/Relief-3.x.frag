#version 140

uniform float Depth;
uniform float Tile;
uniform int LinearSearchSteps;
uniform int BinarySearchSteps;
   
in vec2 ex_TexCoord;
in vec3 ex_EyeSpaceVert;
in vec3 ex_EyeSpaceTangent;
in vec3 ex_EyeSpaceBinormal;
in vec3 ex_EyeSpaceNormal;
in vec3 ex_EyeSpaceLight;

uniform sampler2D DiffuseMap;
uniform sampler2D NormalMap;

in vec4 ex_AmbientLight;
in vec4 ex_MatAmbient;
in vec4 ex_MatDiffuse;
in vec4 ex_MatSpecular;
in float ex_MatShininess;
in vec4 ex_LightSpecular;
in vec4 ex_LightDiffuse;
in vec4 ex_LightAmbient;

out vec4 out_FragColor;

float RayIntersectRM( in vec2 dp, in vec2 ds);

void main()
{
	vec4 l_vAmbient = ex_AmbientLight * ex_MatAmbient;
	vec4 l_vSpecular = vec4( 0.0);
	vec4 l_vDiffuse = vec4( 0.0);
	float l_fShine = ex_MatShininess;

	l_vAmbient += ex_LightAmbient;
	l_vSpecular += ex_LightSpecular;
	l_vDiffuse += ex_LightDiffuse;

	vec4 l_vTextureRelief;
	vec4 l_vTextureColour;
	vec3 l_vTmp1;
	vec3 l_vTmp2;
	vec3 l_eyeSpaceVertex;
	vec3 l_vLightDirection;
	vec2 l_vUV;
	float l_fDot;
	float d;
	vec2 dp, ds;

	// ray intersect in view direction
	l_vTmp2  = ex_EyeSpaceVert;
	l_eyeSpaceVertex = normalize( l_vTmp2);
	l_fDot  = dot( ex_EyeSpaceNormal, -l_eyeSpaceVertex);
	l_vTmp1  = normalize( vec3( dot( l_eyeSpaceVertex, ex_EyeSpaceTangent), dot( l_eyeSpaceVertex, ex_EyeSpaceBinormal), l_fDot));
	l_vTmp1  *= Depth / l_fDot;
	dp = ex_TexCoord * Tile;
	ds = l_vTmp1.xy;
	d  = RayIntersectRM( dp, ds);

	// get rm and color texture points
	l_vUV = dp + ds * d;
	l_vTextureRelief = texture2D( NormalMap, l_vUV);
	l_vTextureColour = texture2D( DiffuseMap, l_vUV);

	// expand normal from normal map in local polygon space
	l_vTextureRelief.xy = l_vTextureRelief.xy * 2.0 - 1.0;
	l_vTextureRelief.z = sqrt( 1.0 - dot( l_vTextureRelief.xy, l_vTextureRelief.xy));
	l_vTextureRelief.xyz = normalize( l_vTextureRelief.x * ex_EyeSpaceTangent + l_vTextureRelief.y * ex_EyeSpaceBinormal + l_vTextureRelief.z * ex_EyeSpaceNormal);

	// compute light direction
	l_vTmp2 += l_eyeSpaceVertex * d * l_fDot;
	l_vLightDirection = normalize( l_vTmp2 - ex_EyeSpaceLight.xyz);
   
	// ray intersect in light direction
	dp += ds * d;
	l_fDot  = dot( ex_EyeSpaceNormal, -l_vLightDirection);
	l_vTmp1  = normalize( vec3( dot( l_vLightDirection, ex_EyeSpaceTangent), dot( l_vLightDirection, ex_EyeSpaceBinormal), l_fDot));
	l_vTmp1 *= Depth / l_fDot;
	ds = l_vTmp1.xy;
	dp -= ds * d;
	float dl = RayIntersectRM( dp, l_vTmp1.xy);
	float l_fShadow = 1.0;
	vec3 l_vSpecularShadow = l_vSpecular.xyz;

	if (dl < d - 0.05) // if pixel in shadow
	{
		l_fShadow = dot( l_vAmbient.xyz, vec3( 1.0)) * 0.333333;
		l_vSpecularShadow = vec3( 0.0);
	}

	// compute diffuse and specular terms
	float l_fAttenuation = max( 0.0, dot( -l_vLightDirection, ex_EyeSpaceNormal));
	float l_fDiffuseTerm = l_fShadow * max( 0.0, dot( -l_vLightDirection, l_vTextureRelief.xyz));
	float l_fSpecularTerm = max( 0.0, dot( normalize( -l_vLightDirection - l_eyeSpaceVertex), l_vTextureRelief.xyz));

	// compute final color
	vec4 l_vFinalColour;
	l_vFinalColour.xyz = l_vAmbient.xyz * l_vTextureColour.xyz + l_fAttenuation * (l_vTextureColour.xyz * l_vDiffuse.xyz * l_fDiffuseTerm + l_vSpecularShadow * pow( l_fSpecularTerm, l_fShine));
	l_vFinalColour.w = 1.0;
	out_FragColor = vec4( l_vFinalColour.rgb, 1.0);
}

float RayIntersectRM( in vec2 p_vDP, in vec2 p_vDS)
{
	float l_fDepthStep = 1.0 / float( LinearSearchSteps);

	// current size of search window
	float l_fSize = l_fDepthStep;
	// current depth position
	float l_fDepth = 0.0;
	// best match found (starts with last position 1.0)
	float l_fDepthReturn = 1.0;
	vec4 l_vTexColour;

	// search front to back for first point inside object
	for (int i = 0 ; i < LinearSearchSteps - 1 ; i++)
	{
		l_fDepth += l_fSize;
		l_vTexColour = texture2D( NormalMap, p_vDP + p_vDS * l_fDepth);

		if (l_fDepthReturn > 0.996)   // if no depth found yet
		{
			if (l_fDepth >= l_vTexColour.w)
			{
				l_fDepthReturn = l_fDepth;   // store best depth
			}
		}
	}

	l_fDepth = l_fDepthReturn;

	// recurse around first point (l_fDepth) for closest match
	for (int i = 0 ; i < BinarySearchSteps ; i++)
	{
		l_fSize *= 0.5;
		l_vTexColour = texture2D( NormalMap, p_vDP + p_vDS * l_fDepth);

		if (l_fDepth >= l_vTexColour.w)
		{
			l_fDepthReturn = l_fDepth;
			l_fDepth -= 2.0 * l_fSize;
		}

		l_fDepth += l_fSize;
	}

	return l_fDepthReturn;
}
