attribute vec3 tangent; 

varying vec2 texCoord;
varying vec3 eyeSpaceVert;
varying vec3 eyeSpaceTangent;
varying vec3 eyeSpaceBinormal;
varying vec3 eyeSpaceNormal;
varying vec3 eyeSpaceLight;

void main(void)
{ 
	vec3 binormal = cross( gl_Normal, tangent);
	vec3 normal = gl_Normal;

	eyeSpaceVert = (gl_ModelViewMatrix * gl_Vertex).xyz;
	
	mat3 tbnMatrix = mat3( eyeSpaceTangent, eyeSpaceBinormal, eyeSpaceNormal);

    eyeSpaceLight = gl_LightSource[0].position.xyz;
                       
	eyeSpaceTangent  = gl_NormalMatrix * tangent;
	eyeSpaceBinormal = gl_NormalMatrix * binormal;
	eyeSpaceNormal   = gl_NormalMatrix * normal;
   
	texCoord   = gl_MultiTexCoord0.xy;
   
	gl_Position = ftransform();
}
