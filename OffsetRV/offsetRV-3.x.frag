#version 140

#define LUMIERE0_ACTIVE 1
#define LUMIERE1_ACTIVE 1
#define LUMIERE2_ACTIVE 1
#define LUMIERE3_ACTIVE 0

#define COEF_LUMIERE0	1.0
#define COEF_LUMIERE1	1.0
#define COEF_LUMIERE2	1.0
#define COEF_LUMIERE3	1.0

#define COEF_AMBIANTE	1.0


#define ACTIVER_OFFSET_MAPPING			1
#define ACTIVER_CORRECTION_OFFSET		1
#define ACTIVER_BUMP_MAPPING			1
#define ACTIVER_OMBRES_INTERNES			1


uniform sampler2D DiffuseMap;
uniform sampler2D HeightMap;
uniform sampler2D NormalMap;
uniform sampler2D OffsetMap;

in float vEchelleHeightMap;
in vec3 eyeVec;

uniform vec3 RVBdiffu;
uniform vec3 RVBspeculaire;


in float vEchelle;

in vec3 PositionVertex;
in vec3 NormaleVertex;

in vec3 Light0_Position;
in vec3 Light1_Position;
in vec3 Light2_Position;
in vec3 Light3_Position;
in vec2 TexCoord;

in vec4 Light0_Ambient;
in vec4 Light1_Ambient;
in vec4 Light2_Ambient;
in vec4 Light3_Ambient;

in vec4 Light0_Diffuse;
in vec4 Light1_Diffuse;
in vec4 Light2_Diffuse;
in vec4 Light3_Diffuse;

out vec4 out_FragColor;

void main()
{
	vec3 CouleurFinale = vec3(0.0);
	vec2 CoordonneesTex0 = TexCoord;
	
	#if ACTIVER_OFFSET_MAPPING == 1
	    float hauteur = texture2D(HeightMap, CoordonneesTex0).r;
    	float v = hauteur * (vEchelleHeightMap * 2.0) - vEchelleHeightMap;
    	vec3 eye = normalize(eyeVec);
    	vec2 DecalageCoordsTex = (eye.xy * v);

    	#if ACTIVER_CORRECTION_OFFSET == 1
			vec4 MinMax = texture2D(OffsetMap, CoordonneesTex0).rgba;
			float Echelle = vEchelle; // 0.6 par défaut
	    	DecalageCoordsTex.x = max(-MinMax.z * Echelle, DecalageCoordsTex.x);
	    	DecalageCoordsTex.x = min(MinMax.x * Echelle, DecalageCoordsTex.x);
	    	DecalageCoordsTex.y = max(-MinMax.y * Echelle, DecalageCoordsTex.y);
	    	DecalageCoordsTex.y = min(MinMax.w * Echelle, DecalageCoordsTex.y);
    	#endif
		
//    	DecalageCoordsTex.y = 0.0;
    	CoordonneesTex0 += DecalageCoordsTex;
    #endif

    vec3 RVB = COEF_AMBIANTE * texture2D(DiffuseMap, CoordonneesTex0).rgb;
	CouleurFinale += RVB;
	
// bump :

	#if ACTIVER_BUMP_MAPPING == 1
		vec3 NormaleBump = texture2D(NormalMap, CoordonneesTex0).xyz * 2.0 - 1.0;
	#else
		vec3 NormaleBump = vec3(0.0, 0.0, 1.0);
	#endif
	
	vec3 DirectionOeil = normalize(-PositionVertex); // origine - PositionVertex
	
//	vec3 RefletLumiere0 = normalize(-reflect(LumiereNormalisee0, NormaleBump));
//	float speculaire0 = pow(max(dot(DirectionOeil, RefletLumiere0), 0.0), 16.0);

	
	#if LUMIERE0_ACTIVE == 1
		vec3 vvRVBdiffu0 = Light0_Diffuse.xyz;//vec3(1.0, 1.0, 0.0);
		vec3 LumiereNormalisee0 = normalize(Light0_Position - PositionVertex); 
		float diffuse0 = max(dot(NormaleBump, LumiereNormalisee0), 0.0);
		vec3 Bump0 =  vec3(COEF_LUMIERE0 * diffuse0) * vvRVBdiffu0.xyz;// + vec3(10.2* pow(diffuse, 16.0)) * vvRVBdiffu.xyz;
		CouleurFinale += Bump0;
	#endif
	#if LUMIERE1_ACTIVE == 1
		vec3 vvRVBdiffu1 = Light1_Diffuse.xyz;//vec3(1.0, 0.0, 0.0);
		vec3 LumiereNormalisee1 = normalize(Light1_Position - PositionVertex); 
		float diffuse1 = max(dot(NormaleBump, LumiereNormalisee1), 0.0);
		vec3 Bump1 =  vec3(COEF_LUMIERE1 * diffuse1) * vvRVBdiffu1.xyz;// + vec3(10.2* pow(diffuse, 16.0)) * vvRVBdiffu.xyz;
		CouleurFinale += Bump1;
	#endif
	#if LUMIERE2_ACTIVE == 1
		vec3 vvRVBdiffu2 = Light2_Diffuse.xyz;//vec3(0.0, 1.0, 0.0);
		vec3 LumiereNormalisee2 = normalize(Light2_Position - PositionVertex); 
		float diffuse2 = max(dot(NormaleBump, LumiereNormalisee2), 0.0);
		vec3 Bump2 =  vec3(COEF_LUMIERE2 * diffuse2) * vvRVBdiffu2.xyz;// + vec3(10.2* pow(diffuse, 16.0)) * vvRVBdiffu.xyz;
		CouleurFinale += Bump2;
	#endif
	#if LUMIERE3_ACTIVE == 1
		vec3 vvRVBdiffu3 = vec3(0.0, 0.0, 1.0);
		vec3 LumiereNormalisee3 = normalize(Light3_Position - PositionVertex); 
		float diffuse3 = max(dot(NormaleBump, LumiereNormalisee3), 0.0);
		vec3 Bump3 =  vec3(COEF_LUMIERE3 * diffuse3) * vvRVBdiffu3.xyz;// + vec3(10.2* pow(diffuse, 16.0)) * vvRVBdiffu.xyz;
		CouleurFinale += Bump3;
	#endif	

	
	
	

	#if LUMIERE0_ACTIVE == 1 && ACTIVER_OMBRES_INTERNES == 1
		float Saturation0 = clamp(diffuse0*1.0 + 0.5, 0.0, 1.0);
		CouleurFinale *= vec3(Saturation0);
	#endif
	#if LUMIERE1_ACTIVE == 1 && ACTIVER_OMBRES_INTERNES == 1
		float Saturation1 = clamp(diffuse1*1.0 + 0.5, 0.0, 1.0);
		CouleurFinale *= vec3(Saturation1);
	#endif
	#if LUMIERE2_ACTIVE == 1 && ACTIVER_OMBRES_INTERNES == 1
		float Saturation2 = clamp(diffuse2*1.0 + 0.5, 0.0, 1.0);
		CouleurFinale *= vec3(Saturation2);
	#endif
	#if LUMIERE3_ACTIVE == 1 && ACTIVER_OMBRES_INTERNES == 1
		float Saturation3 = clamp(diffuse3*1.0 + 0.5, 0.0, 1.0);
		CouleurFinale *= vec3(Saturation3);
	#endif

	out_FragColor = vec4(CouleurFinale.xyz, 1.0);  
//	gl_FragColor = vec4( Light0_Position, 1.0);
}

