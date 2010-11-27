varying vec3 lightVector[gl_MaxLights];
varying vec3 eyeVector;
varying vec2 TexCoord;

uniform sampler2D colorMap;
uniform sampler2D heightMap;
uniform sampler2D normalMap;

void main()
{
	float scale = 0.01;
	vec4 ambientColor = gl_FrontMaterial.ambient;
	vec4 diffuseColor = gl_FrontMaterial.diffuse;
	// Setting the bias this way is presented in "Parallax Mapping with Offset Limiting:
	// A Per Pixel Approximation of Uneven Surfaces" by Terry Walsh.  See Section 4.1
	// for a detailed explanation.
	float bias = scale * 0.5;

	vec3 normalizedEyeVector = normalize( eyeVector );

	vec3 heightVector = texture2D( heightMap, TexCoord).xyz;
	float height = scale * length( heightVector) - bias;
	vec2 nextTextureCoordinate = height * normalizedEyeVector.xy + TexCoord;

	vec3 offsetNormal = texture2D( normalMap, nextTextureCoordinate).xyz;

	// [0, 1] -> [-1, 1]
	offsetNormal = offsetNormal * 2.0 - 1.0;

	float diffuseContribution = 0.0;
	vec3 normalizedLightDirection;

	for (int i = 0 ; i < gl_MaxLights ; i++)
	{
		normalizedLightDirection = normalize( lightVector[i]) / gl_MaxLights;
		diffuseContribution += clamp( dot( offsetNormal, normalizedLightDirection), 0.0, 1.0);
	}

	vec4 textureColor = texture2D( colorMap, nextTextureCoordinate);

	gl_FragColor = (ambientColor + diffuseColor * diffuseContribution) * textureColor;
}