varying vec3 lightVec[gl_MaxLights];
varying vec3 viewVec;
attribute vec3 tangent;

void main( void)
{
	gl_TexCoord[0] = gl_MultiTexCoord0;

	vec3 vTangent = normalize( tangent);
	vec3 vBinormal = cross( tangent, gl_Normal);

	vec4 vVertex = gl_ModelViewMatrix * gl_Vertex;

	for (int i = 0 ; i < gl_MaxLights ; i++)
	{
		lightVec[i] = gl_LightSource[i].position.xyz - vVertex.xyz;
	}

	viewVec = -vVertex.xyz;

	gl_Position = ftransform();
}