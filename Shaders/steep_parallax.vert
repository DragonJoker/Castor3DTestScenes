varying vec3 lightVector[gl_MaxLights];
varying vec3 eyeVector;
varying vec2 TexCoord;

attribute vec3 tangent;
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 MultiTexCoord0;

uniform mat4 ProjectionMatrix;
uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;

void main()
{
	gl_Position = ProjectionMatrix * ModelViewMatrix * vertex;

	vec3 cameraInWorldSpace = gl_Position.xyz * ModelViewMatrix[3].xyz;

	TexCoord = MultiTexCoord0;

	vec3 binormal;
	binormal = cross( normal, tangent);  
	binormal = normalize( binormal);

   	mat3 tangentBinormalNormalMatrix = mat3( tangent, binormal, normal);

	vec4 vVertex = ModelViewMatrix * vertex;

	for (int i = 0 ; i < gl_MaxLights ; i++)
	{
		lightVector[i] = gl_LightSource[i].position.xyz;
	}

	eyeVector = cameraInWorldSpace - (ModelViewMatrix * vertex).xyz;
}