varying vec3 normal, eyeVec;
varying vec3 lightDir[gl_MaxLights];

void main()
{
	gl_Position = ftransform();
	normal = gl_NormalMatrix * gl_Normal;
	vec4 vVertex = gl_ModelViewMatrix * gl_Vertex;
	eyeVec = -vVertex.xyz;
	int i;

	for (i = 0; i < gl_MaxLights; ++i)
	{
		lightDir[i] = gl_LightSource[i].position.xyz;
	}
}