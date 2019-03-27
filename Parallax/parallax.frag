uniform vec2 Scale;
uniform sampler2D DiffuseMap;
uniform sampler2D HeightMap;

varying vec3 eyeVec;
varying vec2 TexCoord;

void main()
{
    vec2 texUV, srcUV = TexCoord;
    float height = texture2D(HeightMap, srcUV).r;
    float v = height * Scale.x - Scale.y;
    vec3 eye = normalize( eyeVec);
	texUV = srcUV + (eye.xy * v);        
        
	vec3 rgb = texture2D( DiffuseMap, texUV).rgb;

	// output final color
	gl_FragColor = vec4(vec3(rgb)*height, 1.0);

   
  
}

