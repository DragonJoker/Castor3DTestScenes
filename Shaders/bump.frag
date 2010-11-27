uniform sampler2D colorMap;
uniform sampler2D normalMap;

varying vec2 TexCoord;
varying vec3 textureLight;
varying vec3 textureEye;

void main()
{
	float diffuseIntensity;
	float specularItensity;

	vec3 light;

	vec3 normal;
	vec3 eye;

	vec3 reflection;

	light = normalize( textureLight);
	
	normal = normalize( texture2D( normalMap, TexCoord).xyz * 2.0 - 1.0 );
	normal.y = -normal.y;	// Left handed to right handed space (Most normal maps are generated for DirectX)
	eye = normalize(textureEye);

	diffuseIntensity = clamp(max(dot(normal, light), 0.0), 0.0, 1.0);
	
	reflection = normalize(reflect(-light, normal));
	specularItensity = pow(clamp(max(dot(reflection, eye), 0.0), 0.0, 1.0), 0.0 );
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0) + vec4(0.0, 0.0, 0.0, 1.0) + texture2D(colorMap, TexCoord)*diffuseIntensity + vec4(0.0, 0.0, 0.0, 1.0)*specularItensity;
}
