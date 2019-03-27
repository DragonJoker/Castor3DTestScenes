#version 140

uniform sampler2D DiffuseMap;
uniform sampler2D NormalMap;

in vec2 TexCoord;
in vec3 textureLight;
in vec3 textureEye;

in vec4 ex_Light0Ambient;
in vec4 ex_Light0Diffuse;
in vec4 ex_Light0Specular;

in vec4 ex_MatAmbient;
in vec4 ex_MatDiffuse;
in vec4 ex_MatSpecular;
in float ex_MatShininess;

void main()
{
	float diffuseIntensity;
	float specularItensity;

	vec3 light;

	vec3 normal;
	vec3 eye;

	vec3 reflection;

	light = normalize( textureLight);
	
	normal = normalize( texture2D( NormalMap, TexCoord).xyz * 2.0 - 1.0 );
	normal.y = -normal.y;	// Left handed to right handed space (Most normal maps are generated for DirectX)
	eye = normalize(textureEye);

	diffuseIntensity = clamp(max(dot(normal, light), 0.0), 0.0, 1.0);
	
	reflection = normalize(reflect(-light, normal));
	specularItensity = pow(clamp(max(dot(reflection, eye), 0.0), 0.0, 1.0), 0.0 );

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0) + texture2D( DiffuseMap, TexCoord) * diffuseIntensity * specularItensity;
}
