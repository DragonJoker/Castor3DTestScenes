varying vec3 lightVec; 
varying vec3 eyeVec;
varying vec2 texCoord;

attribute vec3 tangent;

void main(void)
{
	gl_Position = ftransform();
	texCoord = gl_MultiTexCoord0.xy;
/*
	vec3 vTangent = normalize( tangent);
	vec3 c1 = cross( gl_Normal, vec3( 0.0, 0.0, 1.0)); 
	vec3 c2 = cross( gl_Normal, vec3( 0.0, 1.0, 0.0)); 

	vec3 n = normalize( gl_NormalMatrix * gl_Normal);
	vec3 t = normalize( gl_NormalMatrix * vTangent);
	vec3 b = cross(n, t);
*/
	vec3 n = gl_Normal;
	vec3 t = tangent;
	vec3 b = cross( t, n);

	vec3 vVertex = vec3( gl_ModelViewMatrix * gl_Vertex);
	vec3 tmpVec = gl_LightSource[0].position.xyz;

	lightVec = tmpVec - vVertex;

	tmpVec = -vVertex;
	eyeVec.x = dot( tmpVec, t);
	eyeVec.y = dot( tmpVec, b);
	eyeVec.z = dot( tmpVec, n);
}