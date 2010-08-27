varying vec2 textureCoordinate;
varying vec3 lightVector[gl_MaxLights];
varying vec3 eyeVector;

attribute vec3 tangent;

void main()
{
	gl_Position = ftransform();
   
	vec3 cameraInWorldSpace = gl_Position.xyz - gl_ModelViewMatrixInverse[3].xyz;

	textureCoordinate = gl_MultiTexCoord0.xy;

	vec3 binormal;
	vec3 vTangent = normalize( tangent);
	binormal = cross( tangent, gl_Normal); 
	binormal = normalize( binormal);

	vec3 normal = gl_Normal;

   	mat3 tangentBinormalNormalMatrix = mat3( vTangent, binormal, normal);

	vec4 vVertex = gl_ModelViewMatrix * gl_Vertex;

	for (int i = 0 ; i < gl_MaxLights ; i++)
	{
		lightVector[i] = (gl_LightSource[i].position - vVertex).xyz;
		lightVector[i] = tangentBinormalNormalMatrix * lightVector[i];
	}

	eyeVector = cameraInWorldSpace - ( gl_ModelViewMatrixInverse * gl_Vertex ).xyz;
//	eyeVector = tangentBinormalNormalMatrix * eyeVector;
}