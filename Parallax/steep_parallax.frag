varying vec3 lightVector[3];
varying vec3 eyeVector;
varying vec2 TexCoord;
varying vec4 ex_MatAmbient;
varying vec4 ex_MatDiffuse;

uniform sampler2D DiffuseMap;
uniform sampler2D HeightMap;
uniform sampler2D NormalMap;

void main()
{
	float scale = 0.01;
	vec4 ambientColor = ex_MatAmbient;
	vec4 diffuseColor = ex_MatDiffuse;
	// Setting the bias this way is presented in "Parallax Mapping with Offset Limiting:
	// A Per Pixel Approximation of Uneven Surfaces" by Terry Walsh.  See Section 4.1
	// for a detailed explanation.
	float bias = scale * 0.5;

	vec3 normalizedEyeVector = normalize( eyeVector);

	vec3 heightVector = texture2D( HeightMap, TexCoord).xyz;
	float height = scale * length( heightVector) - bias;
	vec2 nextTextureCoordinate = height * normalizedEyeVector.xy + TexCoord;

	vec3 offsetNormal = texture2D( NormalMap, nextTextureCoordinate).xyz;

	// [0, 1] -> [-1, 1]
	offsetNormal = offsetNormal * 2.0 - 1.0;

	float diffuseContribution = 0.0;
	vec3 normalizedLightDirection;

	for (int i = 0 ; i < 2 ; i++)
	{
		normalizedLightDirection = normalize( lightVector[i]) / 2.0;
		diffuseContribution += clamp( dot( offsetNormal, normalizedLightDirection), 0.0, 1.0);
	}

	vec4 textureColor = texture2D( DiffuseMap, nextTextureCoordinate);

	gl_FragColor = (ambientColor + diffuseColor * diffuseContribution) * textureColor;
}