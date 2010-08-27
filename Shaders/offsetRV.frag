
#define LUMIERE0_ACTIVE 1
#define LUMIERE1_ACTIVE 1
#define LUMIERE2_ACTIVE 0
#define LUMIERE3_ACTIVE 0

#define COEF_LUMIERE0	0.3
#define COEF_LUMIERE1	0.3
#define COEF_LUMIERE2	1.0
#define COEF_LUMIERE3	1.0

#define COEF_AMBIANTE	1.0


#define ACTIVER_OFFSET_MAPPING			1
#define ACTIVER_CORRECTION_OFFSET		1
#define ACTIVER_BUMP_MAPPING			1
#define ACTIVER_OMBRES_INTERNES			1


uniform sampler2D Tex_ambiant;
uniform sampler2D Tex_hauteur;
uniform sampler2D Tex_NormalMap;
uniform sampler2D Tex_OffsetEx;

varying float vEchelleHeightMap;
varying vec3 eyeVec;

uniform vec3 RVBdiffu;
uniform vec3 RVBspeculaire;


varying float vEchelle;

varying vec3 PositionVertex;
varying vec3 NormaleVertex;

varying vec3 Light0_Position;
varying vec3 Light1_Position;
varying vec3 Light2_Position;
varying vec3 Light3_Position;



void main()
{
	vec3 CouleurFinale = vec3(0.0);
	vec2 CoordonneesTex0 = gl_TexCoord[0].xy;
	
	#if ACTIVER_OFFSET_MAPPING == 1
	    float hauteur = texture2D(Tex_hauteur, CoordonneesTex0).r;
    	float v = hauteur * (vEchelleHeightMap * 2.0) - vEchelleHeightMap;
    	vec3 eye = normalize(eyeVec);
    	vec2 DecalageCoordsTex = (eye.xy * v);

    	#if ACTIVER_CORRECTION_OFFSET == 1
			vec4 MinMax = texture2D(Tex_OffsetEx, CoordonneesTex0).rgba;
	   	 
//	    	DecalageCoordsTex.x = max(-MinMax.z, DecalageCoordsTex.x);
//	    	DecalageCoordsTex.x = min(MinMax.x, DecalageCoordsTex.x);
	    //	DecalageCoordsTex.y = min(-MinMax.y, DecalageCoordsTex.y);
	    //	DecalageCoordsTex.y = max(MinMax.a, DecalageCoordsTex.y);
	    
			float Echelle = vEchelle; // 0.6 par défaut
	    	DecalageCoordsTex.x = max(-MinMax.z * Echelle, DecalageCoordsTex.x);
	    	DecalageCoordsTex.x = min(MinMax.x * Echelle, DecalageCoordsTex.x);
	    	DecalageCoordsTex.y = max(-MinMax.a * Echelle, DecalageCoordsTex.y);
	    	DecalageCoordsTex.y = min(MinMax.y * Echelle, DecalageCoordsTex.y);
	    
    	#endif
    		DecalageCoordsTex.y = 0.0;
    	CoordonneesTex0 += DecalageCoordsTex;
    #endif

    vec3 RVB = COEF_AMBIANTE * texture2D(Tex_ambiant, CoordonneesTex0).rgb;
	CouleurFinale += RVB;
	
// bump :

	#if ACTIVER_BUMP_MAPPING == 1
		vec3 NormaleBump = texture2D(Tex_NormalMap, CoordonneesTex0).xyz * 2.0 - 1.0;
	#else
		vec3 NormaleBump = vec3(0.0, 0.0, 1.0);
	#endif
	
	vec3 DirectionOeil = normalize(-PositionVertex); // origine - PositionVertex
	
//	vec3 RefletLumiere0 = normalize(-reflect(LumiereNormalisee0, NormaleBump));
//	float speculaire0 = pow(max(dot(DirectionOeil, RefletLumiere0), 0.0), 16.0);

	
	#if LUMIERE0_ACTIVE == 1
		vec3 vvRVBdiffu0 = vec3(1.0, 1.0, 0.0);
		vec3 LumiereNormalisee0 = normalize(Light0_Position - PositionVertex); 
		float diffuse0 = max(dot(NormaleBump, LumiereNormalisee0), 0.0);
		vec3 Bump0 =  vec3(COEF_LUMIERE0 * diffuse0) * vvRVBdiffu0.xyz;// + vec3(10.2* pow(diffuse, 16.0)) * vvRVBdiffu.xyz;
		CouleurFinale += Bump0;
	#endif
	#if LUMIERE1_ACTIVE == 1
		vec3 vvRVBdiffu1 = vec3(1.0, 0.0, 0.0);
		vec3 LumiereNormalisee1 = normalize(Light1_Position - PositionVertex); 
		float diffuse1 = max(dot(NormaleBump, LumiereNormalisee1), 0.0);
		vec3 Bump1 =  vec3(COEF_LUMIERE1 * diffuse1) * vvRVBdiffu1.xyz;// + vec3(10.2* pow(diffuse, 16.0)) * vvRVBdiffu.xyz;
		CouleurFinale += Bump1;
	#endif
	#if LUMIERE2_ACTIVE == 1
		vec3 vvRVBdiffu2 = vec3(0.0, 1.0, 0.0);
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

	
	
	
//	CouleurFinale.xyz = vec3(MinMax.a);
	gl_FragColor = vec4(CouleurFinale.xyz, 1.0);  
//	gl_FragColor = vec4(vec3(diffuse0).xyz, 1.0);  
//gl_FragColor = vec4(vec3(length(eyeVec)*0.1).xyz, 1.0); 
//	gl_FragDepth = length(eyeVec.xyz);
}

